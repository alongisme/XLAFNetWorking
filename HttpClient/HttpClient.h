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

#pragma mark ----------------------Create Request----------------------

/**
 *  创建普通接口请求
 *
 *  @param requestMode  请求模型
 *  @param success      成功回调
 *  @param failure      失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  请求结束回调
 *
 *  @return 返回请求对象
 */
- (HttpRequest *)requestApiWithHttpRequestMode:(HttpRequestMode *)requestMode
                                       success:(CompletionHandlerSuccessBlock)success
                                       failure:(CompletionHandlerFailureBlock)failure
                                  requsetStart:(RequstStartBlock)requestStart
                                   responseEnd:(ResponseEndBlock)responseEnd;

/**
 *  上传文件接口请求
 *
 *  @param requestMode  请求模型
 *  @param progress     进度条回调
 *  @param success      成功回调
 *  @param failure      失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  请求结束回调
 *
 *  @return 返回请求对象
 */
- (HttpRequest *)uploadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                       progress:(UploadProgressBlock)progress
                                        success:(CompletionHandlerSuccessBlock)success
                                        failure:(CompletionHandlerFailureBlock)failure
                                   requsetStart:(RequstStartBlock)requestStart
                                    responseEnd:(ResponseEndBlock)responseEnd;

/**
 *  下载文件接口请求
 *
 *  @param requestMode  请求模型
 *  @param progress     进度条回调
 *  @param destination  文件保存路径回调
 *  @param success      成功回调
 *  @param failure      失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  请求结束回调
 *
 *  @return 返回请求对象
 */
- (HttpRequest *)downloadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                         progress:(UploadProgressBlock)progress
                                      destination:(downloadDestinationBlock)destination
                                          success:(CompletionHandlerSuccessBlock)success
                                          failure:(CompletionHandlerFailureBlock)failure
                                     requsetStart:(RequstStartBlock)requestStart
                                      responseEnd:(ResponseEndBlock)responseEnd;

@end
