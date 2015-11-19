//
// Created by Chenyu Lan on 8/27/14.
// Copyright (c) 2014 Fenbi. All rights reserved.
//

/*
 YTKUrlFilterProtocol 接口用于实现对网络请求URL或参数的重写，例如可以统一为网络请求加上一些参数，或者修改一些路径。
 
 例如：在猿题库中，我们需要为每个网络请求加上客户端的版本号作为参数。所以我们实现了如下一个 YTKUrlArgumentsFilter 类，实现了 YTKUrlFilterProtocol 接口:
 
 
 通过以上YTKUrlArgumentsFilter 类，我们就可以用以下代码方便地为网络请求增加统一的参数，如增加当前客户端的版本号：
 
 在 didFinishLaunchingWithOptions 中处理
 
 NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
 YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
 YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
 [config addUrlFilter:urlFilter];
 
 */

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"

/// 给url追加arguments，用于全局参数，比如AppVersion, ApiVersion等
@interface YTKUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

//  这里不用再次声明这个方法，
//- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end
