//
//  YTKBaseRequest.m
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

#import "YTKBaseRequest.h"
#import "YTKNetworkAgent.h"
#import "YTKNetworkPrivate.h"

@interface YTKBaseRequest ()

@end

@implementation YTKBaseRequest

/// for subclasses to overwrite
- (void)requestCompleteFilter {
}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    return nil;
}

//默认get请求
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

//默认http参数
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (id)jsonValidator {
    return nil;
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

/// append self to request queue
- (void)start {
    [self ytk_toggleAccessoriesWillStartCallBack];
    [[YTKNetworkAgent sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop {
    [self ytk_toggleAccessoriesWillStopCallBack];
    self.delegate = nil;        // TODO: 这里能将代理随便置为 nil ？？
    [[YTKNetworkAgent sharedInstance] cancelRequest:self];
    [self ytk_toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    return self.requestOperation.isExecuting;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                                    failure:(void (^)(YTKBaseRequest *request))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                              failure:(void (^)(YTKBaseRequest *request))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - setter 

- (void)setSuccessCompletionBlock:(void (^)(YTKBaseRequest *))successCompletionBlock {
    _successCompletionBlock = successCompletionBlock;
}

- (void)setFailureCompletionBlock:(void (^)(YTKBaseRequest *))failureCompletionBlock {
    _failureCompletionBlock = failureCompletionBlock;
}

#pragma mark - getter

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}

- (NSString *)responseString {
    return self.requestOperation.responseString;
}

- (NSInteger)responseStatusCode {
    return self.requestOperation.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.requestOperation.response.allHeaderFields;
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YTKRequestAccessoryDelegate>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

#pragma mark - 断点续传

- (NSString *)resumableDownloadPath {
    return nil;
}

- (AFDownloadProgressBlock)resumableDownloadProgressBlock {
    return nil;
}

@end
