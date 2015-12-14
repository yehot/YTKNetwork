//
//  RegisterApi.h
//  Solar
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 fenbi. All rights reserved.
//

/*
    YTKNetwork 的基本的思想是  把每一个网络请求封装成对象：
    1、网络请求对象 包括以下属性：
        请求的url
        请求的方式：post、get
        请求的参数：
    所以使用 YTKNetwork，你的每一种请求都需要继承 YTKRequest类，通过覆盖父类的一些方法来构造指定的网络请求。
 
 
 */

//#import "YTKBaseRequest.h"
#import "YTKRequest.h"

// TODO: 这里命名规范下，统一 叫 xxxRequest。这样外部调用的时候，xxxRequest startWithCompletionBlockWithSuccess:
@interface RegisterApi : YTKRequest

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

//- (NSString *)userId;

@end
