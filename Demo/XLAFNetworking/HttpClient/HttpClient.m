//
//  HttpClient.m
//  XLAFNetworking
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

#pragma mark 单例
static HttpClient *httpClient = nil;
+ (HttpClient *)sharedInstance {
    
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^{
        if(httpClient == nil) {
            httpClient = [[HttpClient alloc]init];
        }
    });
    
    return httpClient;
}

/**
 *  校验网络状态
 *  网络状态
 *  1 网络不通
 *  2 WIFI
 *  3 3G 4G
 *  4 未知
 *  @param block 回调
 */
- (void)checkNetworkingStatus:(NetwokingStatusBlcok)block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                //网络不通
                if(block) {
                    block(AFNetworkReachabilityStatusNotReachable);
                }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //WiFi
                if(block) {
                    block(AFNetworkReachabilityStatusReachableViaWiFi);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //无线连接
                if(block) {
                    block(AFNetworkReachabilityStatusReachableViaWWAN);
                }
                break;
            case AFNetworkReachabilityStatusUnknown:
                //未知
                if(block) {
                    block(AFNetworkReachabilityStatusUnknown);
                }
                break;
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)requestWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                           Success:(CompletionHandlerSuccessBlock)success
                           Failure:(CompletionHandlerFailureBlock)failure
                      RequsetStart:(RequstStartBlock)requestStart
                       ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequestMode *requestM = [HttpRequestMode new];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(requestM) weakRquestM = requestM;
    
    requestM.Complete = ^ {
        [weakSelf requestBaseWithRequestMode:weakRquestM Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    };
    
    if(requestMode) {
        requestMode(requestM);
    }
}

- (HttpRequest *)uploadPhotoWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                                       Progress:(UploadProgressBlock)progress
                                        Success:(CompletionHandlerSuccessBlock)success
                                        Failure:(CompletionHandlerFailureBlock)failure
                                   RequsetStart:(RequstStartBlock)requestStart
                                    ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *httpRequest = [[HttpRequest alloc]init];
    
    HttpRequestMode *requestM = [HttpRequestMode new];
    
    __weak typeof(requestM) weakRquestM = requestM;
    
    requestM.Complete = ^ {
        [httpRequest uploadRequestWithRequestMode:weakRquestM];
        [httpRequest uploadStartRequsetWithUnitSize:UntiSizeIsKByte Progress:progress SuccessBlock:success FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    };
    
    if(requestMode) {
        requestMode(requestM);
    }
    
    return httpRequest;
}

- (HttpRequest *)downloadPhotoWithHttpRequestMode:(void (^)(HttpRequestMode *request))requestMode
                                         Progress:(UploadProgressBlock)progress
                                      Destination:(downloadDestinationBlock)destination
                                          Success:(CompletionHandlerSuccessBlock)success
                                          Failure:(CompletionHandlerFailureBlock)failure
                                     RequsetStart:(RequstStartBlock)requestStart
                                      ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *httpRequest = [[HttpRequest alloc]init];
    
    HttpRequestMode *requestM = [HttpRequestMode new];
    
    __weak typeof(requestM) weakRquestM = requestM;
    
    requestM.Complete = ^ {
        [httpRequest downloadRequestWithRequestMode:weakRquestM];
        [httpRequest downloadStartRequsetWithUnitSize:UntiSizeIsByte Progress:progress Destination:destination SuccessBlock:success FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    };
    
    if(requestMode) {
        requestMode(requestM);
    }
    
    return httpRequest;
}

//通一请求类
- (void)requestBaseWithRequestMode:(HttpRequestMode *)requestMode
                           Success:(CompletionHandlerSuccessBlock)success
                           Failure:(CompletionHandlerFailureBlock)failure
                      RequsetStart:(RequstStartBlock)requestStart
                       ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *request = [[HttpRequest alloc]initWithRequestWithRequestMode:requestMode];
    [request startRequestWithSuccessBlock:success FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    
}
@end
