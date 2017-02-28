// AFHTTPRequestOperation.h
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "AFURLConnectionOperation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 子类的 头文件里 暴露的接口很少
 */
@interface AFHTTPRequestOperation : AFURLConnectionOperation

#pragma mark - response information
/**
    AFURLConnectionOperation 中是 NSHTTPURLResponse *response （类型不同）
 */
@property (readonly, nonatomic, strong, nullable) NSHTTPURLResponse *response;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

@property (readonly, nonatomic, strong, nullable) id responseObject;

#pragma mark - Completion Block

- (void)setCompletionBlockWithSuccess:(nullable void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(nullable void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
