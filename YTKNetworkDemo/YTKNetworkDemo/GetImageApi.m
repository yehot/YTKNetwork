//
//  GetImageApi.m
//  YTKNetworkDemo
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

#import "GetImageApi.h"

@implementation GetImageApi {
    NSString *_imageId;
}

- (id)initWithImageId:(NSString *)imageId {
    self = [super init];
    if (self) {
        _imageId = imageId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"/iphone/images/%@", _imageId];
}

/*
 如果要使用CDN地址，只需要覆盖 YTKRequest 类的 - (BOOL)useCDN;方法。
 
 例如我们有一个取图片的接口，地址是 http://fen.bi/image/imageId ，则我们可以这么写代码:
 */

- (BOOL)useCDN {
    return YES;
}


//要启动断点续传功能，只需要覆盖 resumableDownloadPath方法，指定断点续传时文件的暂存路径即可。
//如下代码将刚刚的取图片的接口改造成了支持断点续传：
- (NSString *)resumableDownloadPath {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:_imageId];
    return filePath;
}

@end
