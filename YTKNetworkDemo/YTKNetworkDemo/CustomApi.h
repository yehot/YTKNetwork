//
//  CustomApi.h
//  YTKNetworkDemo
//
//  Created by yehot on 15/11/13.
//  Copyright © 2015年 yuantiku.com. All rights reserved.
//

/*
 通过覆盖buildCustomUrlRequest方法，返回一个NSUrlRequest对象来达到完全自定义请求的需求。该方法定义在YTKBaseRequest类，如下：
 
 // 构建自定义的UrlRequest，
 // 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType,requestHeaderFieldValueDictionary
 - (NSURLRequest *)buildCustomUrlRequest;
 
 */

#import "YTKBaseRequest.h"

@interface CustomApi : YTKBaseRequest

@end
