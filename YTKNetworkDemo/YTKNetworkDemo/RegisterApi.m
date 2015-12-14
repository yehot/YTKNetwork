//
//  RegisterApi.m
//  Solar
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

#import "RegisterApi.h"

#define URL_GET_HOME_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/getHp_N"



@implementation RegisterApi {
    NSString *_strRow;
    NSString *_strDate;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        //这里传入的请求参数，在 [self requestArgument] 中使用
        _strRow = username;
        _strDate = password;
    }
    return self;
}

#pragma mark - 重写父类方法 （request）
#pragma mark 请求的 url
//通过覆盖 YTKRequest 类的 requestUrl方法，实现了指定网址信息。。
- (NSString *)requestUrl {
//    return @"/iphone/register";
    //  这里如果只填除去域名剩余的网址信息，会调用 YTKNetworkConfig 的统一域名
    //  如果 未配置YTKNetworkConfig 的统一域名，这里需要填写完整url
    //  （如果设置了统一域名，这里填写完整url也不会报错）
    return URL_GET_HOME_CONTENT;
}

#pragma mark 请求方式
//通过覆盖 YTKRequest 类的 requestMethod方法，实现了指定 POST 方法来传递参数。
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

#pragma mark 请求的参数
//我们通过覆盖 YTKRequest 类的 requestArgument方法，设置请求参数信息
- (id)requestArgument {
    return @{
        @"strRow": @1,
        @"strDate": @"2015-11-20"
    };
}

#pragma mark - 缓存

- (NSInteger)cacheTimeInSeconds {
    return 10;
}

//- (BOOL)isDataFromCache {
//    return YES;
//}

//
//
//- (id)jsonValidator {
//    return @{
//        @"userId": [NSNumber class],
//        @"nick": [NSString class],
//        @"level": [NSNumber class]
//    };
//}
//
//- (NSString *)userId {
//    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
//}

@end
