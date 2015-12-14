//
//  YTKNetworkConfig.m
//
//  Copyright (c) 2012-2014 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKNetworkConfig.h"
#import "YTKNetworkPrivate.h"

@implementation YTKNetworkConfig {
    NSMutableArray *_urlFilters;
    NSMutableArray *_cacheDirPathFilters;
}

+ (YTKNetworkConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _urlFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
        _baseUrlComponents = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addUrlFilter:(id<YTKUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

- (void)addCacheDirPathFilter:(id<YTKCacheDirPathFilterProtocol>)filter {
    [_cacheDirPathFilters addObject:filter];
}

- (NSArray *)urlFilters {
    return [_urlFilters copy];
}

- (NSArray *)cacheDirPathFilters {
    return [_cacheDirPathFilters copy];
}

- (void)addBaseURLComponentWithkey:(NSString *)key andValue:(NSString *)value {
    NSAssert(key && value, @"key or value can't set nil!");
    if (_baseUrlComponents != nil) {
        if (key != nil && value != nil) {
            [_baseUrlComponents setValue:value forKey:key];
        }
    }
}

#pragma mark - getter

//- (NSMutableDictionary *)baseUrlComponents {
//    if (!_baseUrlComponents) {
//        _baseUrlComponents = [NSMutableDictionary dictionary];
//    }
//    return _baseUrlComponents;
//}

- (BOOL)hasBaseUrl {
    return (self.baseUrl.length > 0);
}

- (BOOL)hasBaseUrlComponent {
    return (self.baseUrlComponents.count > 0);
}


//  TODO: 此方法不需要，只调用第一行即可
//- (NSString *)appendComponentDict:(NSDictionary *)component toOriginUrl:(NSString *)originUrl {
//    
////    [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:component];
//    
//    
//    NSString *urlWithFilter = [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:component];
//    return urlWithFilter;
//}

@end
