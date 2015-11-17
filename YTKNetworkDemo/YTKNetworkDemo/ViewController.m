//
//  ViewController.m
//  YTKNetworkDemo
//
//  Created by Chenyu Lan on 10/28/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

#import "ViewController.h"
#import "GetImageApi.h"
#import "GetUserInfoApi.h"
#import "RegisterApi.h"
//#import "YTKBaseRequest.h"

@interface ViewController () <YTKRequestDelegate> {
    NSString *username;
    NSString *password;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    username = @"name";
    password = @"pass";
    
    [self startRequestUseBlock];
    
//    [self startRequestUseDelegate];
    
}

#pragma mark - 使用block发起请求

- (void)startRequestUseBlock {
    
    //1、请求对象
    //      1.传入请求参数，2.对象内部设置了请求方式，3，
    RegisterApi *api = [[RegisterApi alloc] initWithUsername:username password:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        // 你可以直接在这里使用 self
        NSLog(@"succeed");
        NSLog(@"%@",request.responseJSONObject);
        //你可以直接在block回调中使用 self，不用担心循环引用。
        //因为 YTKRequest 会在执行完 block 回调之后，将相应的 block 设置成 nil。从而打破循环引用。
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
        NSLog(@"%@",request.responseHeaders);
    }];
}

#pragma mark - YTKRequestDelegate
//  使用 delegate 方式发起请求
- (void)startRequestUseDelegate {
    
    RegisterApi *api = [[RegisterApi alloc] initWithUsername:username password:password];
    api.delegate = self;
    [api start];
}

- (void)requestFinished:(YTKBaseRequest *)request {
    NSLog(@"succeed");
    
//    request.
}

- (void)requestFailed:(YTKBaseRequest *)request {
    NSLog(@"failed");
}

#pragma mark - 加载上次的缓存

/*
 在实际开发中，有一些内容可能会加载很慢，我们想先显示上次的内容，等加载成功后，再用最新的内容替换上次的内容。也有时候，由于网络处于断开状态，为了更加友好，我们想显示上次缓存中的内容。这个时候，可以使用 YTKReqeust 的直接加载缓存的高级用法。
 
 具体的方法是直接使用YTKRequest的- (id)cacheJson方法，即可获得上次缓存的内容。当然，你需要把- (NSInteger)cacheTimeInSeconds覆盖，返回一个大于等于0的值，这样才能开启YTKRequest的缓存功能，否则默认情况下，缓存功能是关闭的。
 
 以下是一个示例，我们在加载用户信息前，先取得上次加载的内容，然后再发送请求，请求成功后再更新界面：
 
 */
- (void)loadCacheData {
    NSString *userId = @"1";
    GetUserInfoApi *api = [[GetUserInfoApi alloc] initWithUserId:userId];
    
    //  先使用缓存，用上次请求的数据 先填充界面
    if ([api cacheJson]) {
        NSDictionary *json = [api cacheJson];
        NSLog(@"json = %@", json);
        // use cached data
    }
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"update ui");
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}


@end
