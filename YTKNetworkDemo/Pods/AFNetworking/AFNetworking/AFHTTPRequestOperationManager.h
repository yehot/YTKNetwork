// AFHTTPRequestOperationManager.h
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#import "AFHTTPRequestOperation.h"
#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"
#import "AFSecurityPolicy.h"
#import "AFNetworkReachabilityManager.h"

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

NS_ASSUME_NONNULL_BEGIN


@interface AFHTTPRequestOperationManager : NSObject <NSSecureCoding, NSCopying>

// baseURL 作用？？？
@property (readonly, nonatomic, strong, nullable) NSURL *baseURL;

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

// 这里暴露 queue 的作用？？？ 允许外部设置的作用？？
@property (nonatomic, strong) NSOperationQueue *operationQueue;

#pragma mark Credential/Security

@property (nonatomic, assign) BOOL shouldUseCredentialStorage;
@property (nonatomic, strong, nullable) NSURLCredential *credential;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

#pragma mark - 

@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

#pragma mark completion queue/group

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign, nullable) dispatch_queue_t completionQueue;
#endif

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;
#else
@property (nonatomic, assign, nullable) dispatch_group_t completionGroup;
#endif

///---------------------------------------------
/// @name Creating and Initializing HTTP Clients
///---------------------------------------------

//非单例
+ (instancetype)manager;

- (instancetype)initWithBaseURL:(nullable NSURL *)url NS_DESIGNATED_INITIALIZER;

#pragma mark - requests

//  直接使用普通 NSURLRequest 对象发起请求
//  下方所有的 Get/Post 最终都是调用这个 HTTPRequestOperationWithRequest
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// 每个请求回调的 Success block 中，包含一个 request Op，以及 response object （是 op 的一个属性）
- (nullable AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(nullable id)parameters
                        success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(nullable id)parameters
                         success:(nullable void (^)(AFHTTPRequestOperation *operation))success
                         failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(nullable id)parameters
                         success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(nullable id)parameters
       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                         success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(nullable id)parameters
                        success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(nullable id)parameters
                          success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

- (nullable AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(nullable id)parameters
                           success:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(nullable void (^)(AFHTTPRequestOperation * __nullable operation, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
