//
//  UploadImageApi.m
//  Solar
//
//  Created by tangqiao on 8/7/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

#import "UploadImageApi.h"

@implementation UploadImageApi {
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return @"/iphone/image/upload";
}

//  我们创建了一个上传图片，然后获得服务器返回的 imageId 的网络请求Api
- (AFConstructingBlock)constructingBodyBlock {
    
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *name = @"image";
        NSString *formKey = @"image";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

- (id)jsonValidator {
    return @{ @"imageId": [NSString class] };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}

@end
