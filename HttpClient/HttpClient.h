//
//  HttpClient.h
//  XLAFNetworking
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "UploadModel.h"
#import "HttpFileLoadProgress.h"
#import "HttpRequestMode.h"

#define HTTPCLIENTSTART [HttpClient sharedInstance]

@interface HttpClient : NSObject
/**
 *  单例
 *
 *  @return 返回实例
 */
+ (id)sharedInstance;

/**
 *  校验网络状态
 *  网络状态
 *  1 网络不通
 *  2 WIFI
 *  3 3G 4G
 *  4 未知
 *  @param block 回调
 */
- (void)checkNetworkingStatus:(NetworingStautBlock)block;

#pragma mark ----------------------Add New Requst----------------------

- (HttpRequest *)requestApiWithHttpRequestMode:(HttpRequestMode *)requestMode
                                       success:(CompletionHandlerSuccessBlock)success
                                       failure:(CompletionHandlerFailureBlock)failure
                                  requsetStart:(RequstStartBlock)requestStart
                                   responseEnd:(ResponseEndBlock)responseEnd;

- (HttpRequest *)uploadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                       progress:(UploadProgressBlock)progress
                                        success:(CompletionHandlerSuccessBlock)success
                                        failure:(CompletionHandlerFailureBlock)failure
                                   requsetStart:(RequstStartBlock)requestStart
                                    responseEnd:(ResponseEndBlock)responseEnd;

- (HttpRequest *)downloadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                         progress:(UploadProgressBlock)progress
                                      destination:(downloadDestinationBlock)destination
                                          success:(CompletionHandlerSuccessBlock)success
                                          failure:(CompletionHandlerFailureBlock)failure
                                     requsetStart:(RequstStartBlock)requestStart
                                      responseEnd:(ResponseEndBlock)responseEnd;

@end
