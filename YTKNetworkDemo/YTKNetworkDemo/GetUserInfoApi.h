//
//  GetUserInfoApi.h
//  YTKNetworkDemo
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

/*
 
 有些时候，由于服务器的Bug，会造成服务器返回一些不合法的数据，如果盲目地信任这些数据，可能会造成客户端Crash。如果加入大量的验证代码，又使得编程体力活增加，费时费力。
 
 使用 YTKRequest 的验证服务器返回值功能，可以很大程度上节省验证代码的编写时间。
 
 例如，我们要向网址 http://www.yuantiku.com/iphone/users 发送一个GET请求，请求参数是 userId 。我们想获得某一个用户的信息，包括他的昵称和等级，我们需要服务器必须返回昵称（字符串类型）和等级信息（数值类型），则可以覆盖jsonValidator方法，实现简单的验证。
 
 */

#import "YTKRequest.h"

@interface GetUserInfoApi : YTKRequest

- (id)initWithUserId:(NSString *)userId;

@end
