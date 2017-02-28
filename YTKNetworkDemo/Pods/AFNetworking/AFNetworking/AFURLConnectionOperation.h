// AFURLConnectionOperation.h
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

#import <Availability.h>
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "AFSecurityPolicy.h"

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

/**
 AFURLConnectionOperation 继承自 NSOperation，并实现了 NSURLConnection 的诸多 delegate 回调：

 - `connection:didReceiveResponse:`
 - `connection:didReceiveData:`
 - `connectionDidFinishLoading:`
 - `connection:didFailWithError:`
 - `connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:`
 - `connection:willCacheResponse:`
 - `connectionShouldUseCredentialStorage:`
 - `connection:needNewBodyStream:`
 - `connection:willSendRequestForAuthenticationChallenge:`
 */

NS_ASSUME_NONNULL_BEGIN

// 继承自 NSOperation
@interface AFURLConnectionOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSSecureCoding, NSCopying>

///-------------------------------
/// @name Accessing Run Loop Modes
///-------------------------------


@property (nonatomic, strong) NSSet *runLoopModes;

#pragma mark Request/response 数据

@property (readonly, nonatomic, strong) NSURLRequest *request;
@property (readonly, nonatomic, strong, nullable) NSURLResponse *response;
@property (readonly, nonatomic, strong, nullable) NSError *error;

@property (readonly, nonatomic, strong, nullable) NSData *responseData;
@property (readonly, nonatomic, copy, nullable) NSString *responseString;
@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;

#pragma mark 证书、安全相关

@property (nonatomic, assign) BOOL shouldUseCredentialStorage;
@property (nonatomic, strong, nullable) NSURLCredential *credential;

///-------------------------------
/// @name Managing Security Policy
///-------------------------------

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

#pragma mark - 

///------------------------
/// @name Accessing Streams
///------------------------

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong, nullable) NSOutputStream *outputStream;

///---------------------------------
/// @name Managing Callback Queues
///---------------------------------

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign, nullable) dispatch_queue_t completionQueue;
#endif

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;
#else
@property (nonatomic, assign, nullable) dispatch_group_t completionGroup;
#endif

///---------------------------------------------
/// @name Managing Request Operation Information
///---------------------------------------------

@property (nonatomic, strong) NSDictionary *userInfo;

#pragma mark - Initializing

//构造方法
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest NS_DESIGNATED_INITIALIZER;

#pragma mark 流程控制

- (void)pause;
- (BOOL)isPaused;
- (void)resume;

#pragma mark 配置后台执行相关

/**
 Specifies that the operation should continue execution after the app has entered the background, and the expiration handler for that background task.

 @param handler A handler to be called shortly before the application’s remaining background time reaches 0. The handler is wrapped in a block that cancels the operation, and cleans up and marks the end of execution, unlike the `handler` parameter in `UIApplication -beginBackgroundTaskWithExpirationHandler:`, which expects this to be done in the handler itself. The handler is called synchronously on the main thread, thus blocking the application’s suspension momentarily while the application is notified.
  */
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(nullable void (^)(void))handler NS_EXTENSION_UNAVAILABLE_IOS("Not available in app extensions.");
#endif

#pragma mark 上传、下载 Progress Callbacks

- (void)setUploadProgressBlock:(nullable void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

- (void)setDownloadProgressBlock:(nullable void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;

#pragma mark - NSURLConnection Delegate Callbacks

/**
 Sets a block to be executed when the connection will authenticate a challenge in order to download its request, as handled by the `NSURLConnectionDelegate` method `connection:willSendRequestForAuthenticationChallenge:`.

 @param block A block object to be executed when the connection will authenticate a challenge in order to download its request. The block has no return type and takes two arguments: the URL connection object, and the challenge that must be authenticated. This block must invoke one of the challenge-responder methods (NSURLAuthenticationChallengeSender protocol).

 If `allowsInvalidSSLCertificate` is set to YES, `connection:willSendRequestForAuthenticationChallenge:` will attempt to have the challenge sender use credentials with invalid SSL certificates.
 */
- (void)setWillSendRequestForAuthenticationChallengeBlock:(nullable void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block;

/**
 Sets a block to be executed when the server redirects the request from one URL to another URL, or when the request URL changed by the `NSURLProtocol` subclass handling the request in order to standardize its format, as handled by the `NSURLConnectionDataDelegate` method `connection:willSendRequest:redirectResponse:`.

 @param block A block object to be executed when the request URL was changed. The block returns an `NSURLRequest` object, the URL request to redirect, and takes three arguments: the URL connection object, the the proposed redirected request, and the URL response that caused the redirect.
 */
- (void)setRedirectResponseBlock:(nullable NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))block;


/**
 Sets a block to be executed to modify the response a connection will cache, if any, as handled by the `NSURLConnectionDelegate` method `connection:willCacheResponse:`.

 @param block A block object to be executed to determine what response a connection will cache, if any. The block returns an `NSCachedURLResponse` object, the cached response to store in memory or `nil` to prevent the response from being cached, and takes two arguments: the URL connection object, and the cached response provided for the request.
 */
- (void)setCacheResponseBlock:(nullable NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))block;

///

/**

 */
+ (NSArray *)batchOfRequestOperations:(nullable NSArray *)operations
                        progressBlock:(nullable void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                      completionBlock:(nullable void (^)(NSArray *operations))completionBlock;

@end

///--------------------
/// @name Notifications
///--------------------

/**
 Posted when an operation begins executing.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingOperationDidFinishNotification;

NS_ASSUME_NONNULL_END
