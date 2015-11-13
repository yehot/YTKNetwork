//
//  RegisterApi.m
//  Solar
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

#import "RegisterApi.h"

@implementation RegisterApi {
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

#pragma mark - 请求的 url
- (NSString *)requestUrl {
    // “http://www.yuantiku.com” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
    return @"/iphone/register";
}
//通过覆盖 YTKRequest 类的 requestUrl方法，实现了指定网址信息。并且我们只需要指定除去域名剩余的网址信息，因为域名信息在 YTKNetworkConfig 中已经设置过了。

#pragma mark - 请求方式
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}
//我们通过覆盖 YTKRequest 类的 requestMethod方法，实现了指定 POST 方法来传递参数。

#pragma mark - 请求的参数
- (id)requestArgument {
    return @{
        @"username": _username,
        @"password": _password
    };
}
//我们通过覆盖 YTKRequest 类的 requestArgument方法，提供了 POST 的信息。这里面的参数 username 和 password 如果有一些特殊字符（如中文或空格），也会被自动编码。

- (id)jsonValidator {
    return @{
        @"userId": [NSNumber class],
        @"nick": [NSString class],
        @"level": [NSNumber class]
    };
}

- (NSString *)userId {
    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
}

@end
