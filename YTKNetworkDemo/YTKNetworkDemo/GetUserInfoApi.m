//
//  GetUserInfoApi.m
//  YTKNetworkDemo
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

#import "GetUserInfoApi.h"

@implementation GetUserInfoApi {
    NSString *_userId;
}

- (id)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/iphone/users";
}

- (id)requestArgument {
    return @{ @"id": _userId };
}

- (id)jsonValidator {
    return @{
        @"nick": [NSString class],
        @"level": [NSNumber class]
    };
}


/*
 我们想像这样一个场景，假设你在完成一个类似微博的客户端，GetUserInfoApi 用于获得你的某一个好友的资料，因为好友并不会那么频繁地更改昵称，那么短时间内频繁地调用这个接口很可能每次都返回同样的内容，所以我们可以给这个接口加一个缓存。
 
 在如下示例中，我们通过覆盖 cacheTimeInSeconds方法，给 GetUserInfoApi 增加了一个3分钟的缓存，3分钟内调用调Api的start方法，实际上并不会发送真正的请求。
 
 该缓存逻辑对上层是透明的，所以上层可以不用考虑缓存逻辑，每次调用 GetUserInfoApi 的start方法即可。GetUserInfoApi只有在缓存过期时，才会真正地发送网络请求。
 */
- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}


/*
以下是更多的jsonValidator的示例：

要求返回String数组：
- (id)jsonValidator {
    return @[ [NSString class] ];
}
来自猿题库线上环境的一个复杂的例子：
- (id)jsonValidator {
    return @[@{
                 @"id": [NSNumber class],
                 @"imageId": [NSString class],
                 @"time": [NSNumber class],
                 @"status": [NSNumber class],
                 @"question": @{
                         @"id": [NSNumber class],
                         @"content": [NSString class],
                         @"contentType": [NSNumber class]
                         }
                 }];
}
*/

@end
