//
//  YTKNetworkAgent.h
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

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

/**
 *  网络请求发起者，不直接调用
 *  内部调用AFN
 */
@interface YTKNetworkAgent : NSObject

+ (YTKNetworkAgent *)sharedInstance;

/**
 *  Agent 通过 add request 对象，添加一个请求
 *  内部再调用 AFN
 *
 */
- (void)addRequest:(YTKBaseRequest *)request;

- (void)cancelRequest:(YTKBaseRequest *)request;

- (void)cancelAllRequests;

//  TODO：此方法没有必要暴露出来
/// 根据request和networkConfig构建url
//- (NSString *)buildRequestUrl:(YTKBaseRequest *)request;

@end
