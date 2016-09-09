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

@interface HttpClient ()

@end

@implementation HttpClient

#pragma mark 单例
static HttpClient *httpClient = nil;
+ (HttpClient *)sharedInstance {
    
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^{
        if(httpClient == nil) {
            httpClient = [[HttpClient alloc]init];
            
#ifdef DEBUG
            [httpClient setDebugMode:YES];
#endif
                        
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
                           Success:(CompletionHandlerSuccessBlock)success
                           Failure:(CompletionHandlerFailureBlock)failure
                      RequsetStart:(RequstStartBlock)requestStart
                       ResponseEnd:(ResponseEndBlock)responseEnd {

    [self setIsCache:NO];
    
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsGET:requestMode.isGET Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];

}

- (void)requestApiCacheWithHttpRequestMode:(HttpRequestMode *)requestMode
                              Success:(CompletionHandlerSuccessBlock)success
                              Failure:(CompletionHandlerFailureBlock)failure
                         RequsetStart:(RequstStartBlock)requestStart
                          ResponseEnd:(ResponseEndBlock)responseEnd {
  
    [self setIsCache:YES];
    
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsGET:requestMode.isGET Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];
}

- (HttpRequest *)uploadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                 Progress:(UploadProgressBlock)progress
                         Success:(CompletionHandlerSuccessBlock)success
                                  Failure:(CompletionHandlerFailureBlock)failure
                             RequsetStart:(RequstStartBlock)requestStart
                              ResponseEnd:(ResponseEndBlock)responseEnd {
  
    HttpRequest *httpRequest = [[HttpRequest alloc]init];

    [httpRequest uploadRequestWithRequestName:requestMode.name UrlString:requestMode.url Parameters:requestMode.parameters PhotoFile:requestMode.uploadModels IsGET:requestMode.isGET];
    
    [httpRequest uploadStartRequsetWithUnitSize:UntiSizeIsKByte Progress:progress SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    
    return httpRequest;
}

- (HttpRequest *)downloadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                         Progress:(UploadProgressBlock)progress
                               Destination:(downloadDestinationBlock)destination
                                   Success:(CompletionHandlerSuccessBlock)success
                                   Failure:(CompletionHandlerFailureBlock)failure
                              RequsetStart:(RequstStartBlock)requestStart
                               ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *httpRequest = [[HttpRequest alloc]init];
    
    [httpRequest downloadRequestWithrequestName:requestMode.name UrlString:requestMode.url];
    
    [httpRequest downloadStartRequsetWithUnitSize:UntiSizeIsByte Progress:progress Destination:destination SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    
    return httpRequest;

}


//普通请求基类
- (void)requestBaseWithName:(NSString *)name
                        Url:(NSString *)url
                 Parameters:(NSDictionary *)parameters
                      IsGET:(BOOL)isGET
                    Success:(CompletionHandlerSuccessBlock)success
                             Failure:(CompletionHandlerFailureBlock)failure
                        RequsetStart:(RequstStartBlock)requestStart
                         ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *httpRequest = [[HttpRequest alloc]init];
    
    //校验网络状态
    [httpRequest checkNetworkingStatus:^(AFNetworkReachabilityStatus status) {
        
        //如果是wifi和wan网就请求数据
        if(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            [httpRequest requestWithRequestName:name UrlString:url?url:@"" Parameters:parameters IsGET:isGET];
            [httpRequest startRequsetWithSuccessBlock:success FailedBlock:failure RequsetStart:requestStart ResponseEnd:^{
                
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
