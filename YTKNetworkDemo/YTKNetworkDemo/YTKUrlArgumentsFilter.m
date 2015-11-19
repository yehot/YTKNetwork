//
// Created by Chenyu Lan on 8/27/14.
// Copyright (c) 2014 Fenbi. All rights reserved.
//

#import "YTKUrlArgumentsFilter.h"
#import "YTKNetworkPrivate.h"

@implementation YTKUrlArgumentsFilter {
    NSDictionary *_arguments;
}

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSDictionary *)urlComponents {
    return _arguments;
}

//  这个方法设计的有问题，应该 将 _arguments 作为参数传入。 和 request 没什么关系（只是追加 url 参数，并不需要 request）
//  可以将 _arguments 改为 readOnly 的属性暴露出去，供外部用，再传入都可。
//  (最好是，作为协议的 readonly 属性)

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    NSString *urlWithFilter = [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
    return urlWithFilter;
}

@end
