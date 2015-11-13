//
//  UploadImageApi.h
//  Solar
//
//  Created by tangqiao on 8/7/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

/*
    我们可以通过覆盖constructingBodyBlock方法，来方便地上传图片等附件
 */

#import "YTKRequest.h"

@interface UploadImageApi : YTKRequest

- (id)initWithImage:(UIImage *)image;

- (NSString *)responseImageId;

@end
