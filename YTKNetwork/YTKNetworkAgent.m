//
//  YTKNetworkAgent.m
//
//  Copyright (c) 2012-2014 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKNetworkAgent.h"
#import "YTKNetworkConfig.h"
#import "YTKNetworkPrivate.h"
#import "AFNetworking.h"

@implementation YTKNetworkAgent {
    AFHTTPRequestOperationManager *_manager;
    NSMutableDictionary *_requestsRecord;
}

+ (YTKNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}

////请求url的处理：加上filter，baseurl等
- (NSString *)buildRequestUrl:(YTKBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    YTKNetworkConfig *_config;
    _config = [YTKNetworkConfig sharedInstance];
    
    //   这里 接口需重构，目的只是为了 给 url 加上 统一参数，不需要这么复杂
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<YTKUrlFilterProtocol> f in filters) {
        
        //Tip: 协议的用法，为 一个类增加一个方法，不写在.h ,而是让这个类遵守 协议，并 在 .m 中实现协议的方法
        //      从 .h 上直观的看，
        // 为 url 追加 统一的参数
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }

    NSString *baseUrl;
    if ([request useCDN]) {         // 此处不用 CDN，无需写
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    }
    else {      // 拼接 base url
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];    //请求单独指定的 base Url
        } else {
            baseUrl = [_config baseUrl];    // 全局的 base URL
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

//  从请求对象取各种参数设置，配置到 AFHTTPRequestOperationManager
//  并用其发起请求
- (void)addRequest:(YTKBaseRequest *)request {
    YTKRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument; //请求参数

    if (request.requestSerializerType == YTKRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == YTKRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];

    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    //   非必须 （设置请求头 ）
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                YTKLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }


    // if api build custom url request
    NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
    if (customUrlRequest) {
        
//        TODO: 这里为什么使用 NSURLRequest 发起请求时， 用 AFHTTPRequestOperation initWithRequest：
//              然后[operation setCompletionBlockWithSuccess：
//          而其它请求，用 manager GET:url parameters:param success:
        
//        1.这里的 NSURLRequest 是一个完整的 request，设置了请求头、get、post 等
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:customUrlRequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // operation.responseObject 就是 responseObject
            //   这里的 成功和失败没有区别对待，原因是 operation 里包含了 responseObject 和 error
            // 这个 block 的两个参数 分别是 （self, self.responseObject）—— 只是为了使用方便
            [self handleRequestResult:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
        request.requestOperation = operation;
        operation.responseSerializer = _manager.responseSerializer;
        [_manager.operationQueue addOperation:operation];   // 加入 queue 后，会自动启动任务？
        
    } else {
        if (method == YTKRequestMethodGet) {
            if (request.resumableDownloadPath) {
                // add parameters to URL;
                NSString *filteredUrl = [YTKNetworkPrivate urlStringWithOriginUrlString:url appendParameters:param];

                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:requestUrl
                                                                                                 targetPath:request.resumableDownloadPath shouldResume:YES];
                [operation setProgressiveDownloadProgressBlock:request.resumableDownloadProgressBlock];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
                request.requestOperation = operation;
                [_manager.operationQueue addOperation:operation];
            }
            else {
                request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
            }
        }
        else if (method == YTKRequestMethodPost) {
            
            //  可以用点语法
            AFConstructingBlock constructingBlock = [request constructingBodyBlock];
            if (constructingBlock != nil) {
                request.requestOperation = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      [self handleRequestResult:operation];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self handleRequestResult:operation];
                        }];
            } else {
                request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation];
                }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation];
                }];
            }
        }
        else if (method == YTKRequestMethodHead) {
            request.requestOperation = [_manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
                [self handleRequestResult:operation];
            }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
        else if (method == YTKRequestMethodPut) {
            request.requestOperation = [_manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
        else if (method == YTKRequestMethodDelete) {
            request.requestOperation = [_manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            }                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
        else if (method == YTKRequestMethodPatch) {
            request.requestOperation = [_manager PATCH:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation];
            }];
        }
        else {
            YTKLog(@"Error, unsupport method type");
            return;
        }
    }

    YTKLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

- (void)cancelRequest:(YTKBaseRequest *)request {
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        YTKBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (BOOL)checkResult:(YTKBaseRequest *)request {
    BOOL result = request.requestOperation.response.statusCode;
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        id json = [request responseJSONObject];
        result = [YTKNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

#pragma mark - 处理请求结果
//回调，在请求成功或失败的AFN 的回调block 里，调用此方法
//  在这里判断，如果有 delegate，用代理回调，如果有block，
//TODO: 这个方法，添加 id 类型 参数：responseObject  error
//      拆成两个方法 successedWithResponse、failedWithRequest

//  这个方法内部 用 operation 去 request字典里取，request
//  而 request里，又包含了 数据、和 operation、错误信息，所以，这里不用区别处理 success 和 failure
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    YTKBaseRequest *request = _requestsRecord[key];
    YTKLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {  //请求成功
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request ytk_toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request ytk_toggleAccessoriesDidStopCallBack];
        } else {
            YTKLog(@"Request %@ failed, status code = %ld",
                     NSStringFromClass([request class]), (long)request.responseStatusCode);
            [request ytk_toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request ytk_toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

/**
 *  将 request 存入 dict （以 hash 作为 key）
 */
- (void)addOperation:(YTKBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
    YTKLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end
