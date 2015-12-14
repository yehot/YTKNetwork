//
//  YTKBaseRequest.h
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

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"

//请求方式
typedef NS_ENUM(NSInteger , YTKRequestMethod) {
    YTKRequestMethodGet = 0,
    YTKRequestMethodPost,
    YTKRequestMethodHead,
    YTKRequestMethodPut,
    YTKRequestMethodDelete,
    YTKRequestMethodPatch
};

//序列化方式
typedef NS_ENUM(NSInteger , YTKRequestSerializerType) {
    YTKRequestSerializerTypeHTTP = 0,
    YTKRequestSerializerTypeJSON,
};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

#pragma mark - YTKRequestDelegate

@class YTKBaseRequest;
@protocol YTKRequestDelegate <NSObject>

@optional

- (void)requestFinished:(YTKBaseRequest *)request;
- (void)requestFailed:(YTKBaseRequest *)request;
- (void)clearRequest;

@end

#pragma mark - YTKRequestAccessoryDelegate

@protocol YTKRequestAccessoryDelegate <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

#pragma mark -

@interface YTKBaseRequest : NSObject

/// Tag
@property (nonatomic) NSInteger tag;

/// User info
@property (nonatomic, strong) NSDictionary *userInfo;

// AFN 实例
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

/// request delegate object
@property (nonatomic, weak) id<YTKRequestDelegate> delegate;

#pragma mark - response
//请求返回
//响应头
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
//返回的sting
@property (nonatomic, strong, readonly) NSString *responseString;
//返回的json数据
@property (nonatomic, strong, readonly) id responseJSONObject;
//返回的状态码
@property (nonatomic, readonly) NSInteger responseStatusCode;

//请求成功的block回调
@property (nonatomic, copy, readonly) void (^successCompletionBlock)(YTKBaseRequest *);
//请求失败的block回调
@property (nonatomic, copy, readonly) void (^failureCompletionBlock)(YTKBaseRequest *);

/// Request Accessory，可以hook Request的start和stop (在请求的开始、进行中、结束时，加入动作)
@property (nonatomic, strong) NSMutableArray *requestAccessories;

#pragma mark - main

/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;

- (BOOL)isExecuting;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                                    failure:(void (^)(YTKBaseRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
                              failure:(void (^)(YTKBaseRequest *request))failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

//  TODO: 这里考虑一个 request 对应多个 delegate 是否有这种需要？？
//  这里改为 使用AccessoryDelegate，而不是数组，只提供一个 accessoryDelegate
/// Request Accessory，可以hook Request的start和stop (在请求的开始、进行中、结束时，加入动作)
- (void)addAccessory:(id<YTKRequestAccessoryDelegate>)accessory;

#pragma mark - 以下方法由子类继承来覆盖默认值

//TODO:使用子类重载父类方法的形式来设置初始化参数，是否可以改为property，或同时提供property

/// 以下方法由子类继承来覆盖默认值

/// 请求成功时会调用 （可以缓存请求数据）
- (void)requestCompleteFilter;

/// 请求失败时会被调用 （可以做retry处理）
- (void)requestFailedFilter;

/// 请求的URL
- (NSString *)requestUrl;

/// 请求的CdnURL
- (NSString *)cdnUrl;

//  请求单独指定 baseURL。如果此方法重写后，返回值不为nil，则认为此 请求对象不使用 全局默认的 统一域名（即 NetworkConfig 中的 baseDomainURL）
/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (id)requestArgument;

/// Http请求的方法
- (YTKRequestMethod)requestMethod;

/// 请求的SerializerType
- (YTKRequestSerializerType)requestSerializerType;

//TODO：此方法并不通用，未copy
/// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数
/*
 通过覆盖requestHeaderFieldValueDictionary方法返回一个dictionary对象来自定义请求的HeaderField，返回的dictionary，其key即为HeaderField的key，value为HeaderField的Value，需要注意的是key和value都必须为string对象。
 */
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

#pragma mark helper method

/// 是否使用CDN的host地址
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
- (id)jsonValidator;

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;

#pragma mark 断点续传

//  TODO: 有必要为断点续传单独设置为一个属性，提供单独的的block回调（暂时不提供delegate回调），或者，单独一个类 BreakPointDownLoadRequest
/// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath;

/// 当需要断点续传时，获得下载进度的回调
- (AFDownloadProgressBlock)resumableDownloadProgressBlock;

@end
