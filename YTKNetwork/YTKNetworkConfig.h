//
//  YTKNetworkConfig.h
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
#import "YTKBaseRequest.h"

//添加url统一参数
@protocol YTKUrlFilterProtocol <NSObject>
@required

//  这个方法不应该交给子类去实现，内部只是
//- (NSDictionary *)
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;
@end

@protocol YTKCacheDirPathFilterProtocol <NSObject>
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(YTKBaseRequest *)request;
@end

/**
 *  设置全局的请求参数，如域名、参数、缓存
 */
@interface YTKNetworkConfig : NSObject

+ (YTKNetworkConfig *)sharedInstance;


//  TODO: baseUrl 重构，只提供 read only 的属性，供外部用，加的时候，用 方法加
/**
 *  配置整个工程请求 统一的 域名：    eg: http:www.519.com/
 *  @code
     YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
     config.baseUrl           = @"http:www.519.com/";
    @endcode
 *  @warning 可在KDS_BaseRequest.m 子类中为 overwrite  baseUrl 方法 手动 为该请求单独指定。
 *
 *  这里设置的 baseurl，只是为了 发起请求前，取出来 拼接 到 url 前
 */
@property (strong, nonatomic) NSString *baseUrl;    //改名为 BaseDomainUrl
@property (strong, nonatomic) NSString *cdnUrl;

/**
 *  这里的 urlFilters 是通过 addUrlFilter: 加入的
 *  @Remark     NSArray<YTKUrlFilterProtocol> 数组中，是 遵守 YTKUrlFilterProtocol 的对象
 */
@property (strong, nonatomic, readonly) NSArray *urlFilters;
@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;

/**
 *  是否设置了 baseUrl
 */
@property (assign, readonly, nonatomic) BOOL hasBaseUrl;
/**
 *   是否设置了baseUrlComponents
 */
@property (assign, readonly, nonatomic) BOOL hasBaseUrlComponent;


/**
 *  添加url统一配置  eg： 为所有的url请求加入版本号参数
 *  @code     
    YTKNetworkConfig *config         = [YTKNetworkConfig sharedInstance];
    YTKUrlArgumentsVersionFilter *urlFilter = [YTKUrlArgumentsVersionFilter filterWithArguments:@{@"version": appVersion}];
    [config addUrlFilter:urlFilter]; 
    @endcode
 */
- (void)addUrlFilter:(id<YTKUrlFilterProtocol>)filter;
- (void)addCacheDirPathFilter:(id <YTKCacheDirPathFilterProtocol>)filter;

@property (strong, readonly, nonatomic) NSMutableDictionary *baseUrlComponents;

- (void)addBaseURLComponentWithkey:(NSString *)key andValue:(NSString *)value;


@end
