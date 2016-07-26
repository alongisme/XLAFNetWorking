//
//  HttpClient.h
//  AFNWorking3_0Demo
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "HttpFileLoadProgress.h"

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
//测试数据
- (HttpRequest *)testApiWithnextPage:(NSString *)nextPage
                   pageSize:(NSString *)pageSize
                     status:(NSString *)status
                   sortData:(NSString *)sortData
                 jsonFilter:(NSString *)jsonFilter
                    success:(CompletionHandlerSuccessBlock)success
                             failure:(CompletionHandlerFailureBlock)failure
                        requsetStart:(RequstStartBlock)requestStart
                         responseEnd:(ResponseEndBlock)responseEnd;

//图片上传测试
- (HttpRequest *)uploadPhotoWithPhotoFile:(NSArray *)PhotoFile
                                 progress:(UploadProgressBlock)progress
                         success:(CompletionHandlerSuccessBlock)success
                                  failure:(CompletionHandlerFailureBlock)failure
                             requsetStart:(RequstStartBlock)requestStart
                              responseEnd:(ResponseEndBlock)responseEnd;

//图片下载测试
- (HttpRequest *)downloadPhotoWithprogress:(UploadProgressBlock)progress
                               destination:(downloadDestinationBlock)destination
                                   success:(CompletionHandlerSuccessBlock)success
                                   failure:(CompletionHandlerFailureBlock)failure
                              requsetStart:(RequstStartBlock)requestStart
                               responseEnd:(ResponseEndBlock)responseEnd;

@end
