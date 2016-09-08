//
//  HttpClient.m
//  XLAFNetworking
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpClient.h"

#define HTTPURL @""
#define HTTPIMAGEURL @""

@interface HttpClient () {
    HttpRequest *httpRequest;
}

@end

@implementation HttpClient

#pragma mark 单例
static HttpClient *httpClient = nil;
+ (id)sharedInstance {
    
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
    HttpRequest *requst = [[HttpRequest alloc]init];
    [requst checkNetworkingStatus:block];
}

- (void)requestApiWithHttpRequestMode:(HttpRequestMode *)requestMode
                           success:(CompletionHandlerSuccessBlock)success
                           failure:(CompletionHandlerFailureBlock)failure
                      requsetStart:(RequstStartBlock)requestStart
                       responseEnd:(ResponseEndBlock)responseEnd {
    
    [self requestBaseWithName:requestMode.name url:requestMode.url parameters:requestMode.parameters isGET:requestMode.isGET success:^(HttpRequest *request, HttpResponse *response) {
        success(request,response);
    } failure:failure requsetStart:requestStart responseEnd:responseEnd];;
}

- (HttpRequest *)uploadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                 progress:(UploadProgressBlock)progress
                         success:(CompletionHandlerSuccessBlock)success
                                  failure:(CompletionHandlerFailureBlock)failure
                             requsetStart:(RequstStartBlock)requestStart
                              responseEnd:(ResponseEndBlock)responseEnd {
  
    httpRequest = [[HttpRequest alloc]init];
    
    [httpRequest uploadRequestWithrequestName:requestMode.name URLString:requestMode.url parameters:requestMode.parameters PhotoFile:requestMode.uploadModels isGET:requestMode.isGET];
    
    [httpRequest uploadStartRequsetWithUnitSize:UntiSizeIsKByte Progress:progress SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return httpRequest;
}

- (HttpRequest *)downloadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                         progress:(UploadProgressBlock)progress
                               destination:(downloadDestinationBlock)destination
                                   success:(CompletionHandlerSuccessBlock)success
                                   failure:(CompletionHandlerFailureBlock)failure
                              requsetStart:(RequstStartBlock)requestStart
                               responseEnd:(ResponseEndBlock)responseEnd {
    
    httpRequest = [[HttpRequest alloc]init];
    
    [httpRequest downloadRequestWithrequestName:requestMode.name URLString:requestMode.url];
    
    [httpRequest downloadStartRequsetWithUnitSize:UntiSizeIsByte Progress:progress destination:destination SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return httpRequest;

}


//普通请求基类
- (void)requestBaseWithName:(NSString *)name
                        url:(NSString *)url
                 parameters:(NSDictionary *)parameters
                      isGET:(BOOL)isGET
                    success:(CompletionHandlerSuccessBlock)success
                             failure:(CompletionHandlerFailureBlock)failure
                        requsetStart:(RequstStartBlock)requestStart
                         responseEnd:(ResponseEndBlock)responseEnd {
    
    httpRequest = [[HttpRequest alloc]init];
    
    //校验网络状态
    [httpRequest checkNetworkingStatus:^(AFNetworkReachabilityStatus status) {
        
        //如果是wifi和wan网就请求数据
        if(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            [httpRequest requestWithrequestName:name URLString:url?url:@"" parameters:parameters isGET:isGET];
            [httpRequest startRequsetWithSuccessBlock:success FailedBlock:failure requsetStart:requestStart responseEnd:^{
                
                //请求结束后 清除request对象 
                httpRequest = nil;
                
                if(responseEnd) {
                    responseEnd();
                }
            }];
        }else {
            
            //其他网络状态就 获取缓存
            [httpRequest getCacheDataWithRequestPath:url Success:success];
            
        }
        
        //判断一次就停止
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        
    }];
    

    
}

@end
