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

@interface HttpClient : NSObject

//URL前缀
@property (nonatomic,copy) NSString *baseUrl;
//所有headfiled
@property (nonatomic,strong) NSDictionary *requestHeadDictionary;
//过滤设置headfiled
@property (nonatomic,strong) NSArray *requestHeadIgnoreUrlArray;
//超时时间
@property (nonatomic,assign) NSUInteger timeoutInterval;

/**
 *  单例
 *
 *  @return 返回实例
 */
+ (HttpClient *)sharedInstance;

/**
 *  校验网络状态
 *  网络状态
 *  1 网络不通
 *  2 WIFI
 *  3 3G 4G
 *  4 未知
 */
- (void)checkNetworkingStatus:(NetwokingStatusBlcok)block;

#pragma mark ----------------------Create Request----------------------
- (void)requestWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                           Success:(CompletionHandlerSuccessBlock)success
                           Failure:(CompletionHandlerFailureBlock)failure
                      RequsetStart:(RequstStartBlock)requestStart
                       ResponseEnd:(ResponseEndBlock)responseEnd;

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
- (HttpRequest *)uploadPhotoWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                                       Progress:(UploadProgressBlock)progress
                                        Success:(CompletionHandlerSuccessBlock)success
                                        Failure:(CompletionHandlerFailureBlock)failure
                                   RequsetStart:(RequstStartBlock)requestStart
                                    ResponseEnd:(ResponseEndBlock)responseEnd;

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
- (HttpRequest *)downloadPhotoWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                                         Progress:(UploadProgressBlock)progress
                                      Destination:(downloadDestinationBlock)destination
                                          Success:(CompletionHandlerSuccessBlock)success
                                          Failure:(CompletionHandlerFailureBlock)failure
                                     RequsetStart:(RequstStartBlock)requestStart
                                      ResponseEnd:(ResponseEndBlock)responseEnd;

@end
