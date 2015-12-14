//
//  AppDelegate.m
//  YTKNetworkDemo
//
//  Created by Chenyu Lan on 10/28/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
#import "YTKUrlArgumentsFilter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self setupRequestFilters];
    return YES;
}

- (void)setupRequestFilters {
    
    //  给项目所有的请求，统一加上版本信息
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
    [config addBaseURLComponentWithkey:nil andValue:nil];
    
    [config addUrlFilter:urlFilter];
}

@end
