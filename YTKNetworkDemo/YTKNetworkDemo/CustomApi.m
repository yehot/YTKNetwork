//
//  CustomApi.m
//  YTKNetworkDemo
//
//  Created by yehot on 15/11/13.
//  Copyright © 2015年 yuantiku.com. All rights reserved.
//

#import "CustomApi.h"

@implementation CustomApi

/*
 如注释所言，如果构建自定义的request，
 会忽略其他的一切自定义request的方法，例如requestUrl, requestArgument, requestMethod, requestSerializerType,requestHeaderFieldValueDictionary。一个上传gzippingData的示例如下：
 */

- (NSURLRequest *)buildCustomUrlRequest {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"www.xxxxx"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setHTTPBody:[@"someStr" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

@end
