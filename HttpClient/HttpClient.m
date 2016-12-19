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

- (void)requestApiWithHttpRequestMode:(HttpRequestMode *)requestMode
                           Success:(CompletionHandlerSuccessBlock)success
                           Failure:(CompletionHandlerFailureBlock)failure
                      RequsetStart:(RequstStartBlock)requestStart
                       ResponseEnd:(ResponseEndBlock)responseEnd {
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsGet:requestMode.isGET IsCache:NO Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];

}

- (void)requestApiCacheWithHttpRequestMode:(HttpRequestMode *)requestMode
                              Success:(CompletionHandlerSuccessBlock)success
                              Failure:(CompletionHandlerFailureBlock)failure
                         RequsetStart:(RequstStartBlock)requestStart
                          ResponseEnd:(ResponseEndBlock)responseEnd {
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsGet:requestMode.isGET IsCache:YES Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];
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


//通一请求累
- (void)requestBaseWithName:(NSString *)name
                        Url:(NSString *)url
                 Parameters:(NSDictionary *)parameters
                      IsGet:(BOOL)isGet
                    IsCache:(BOOL)isCache
                    Success:(CompletionHandlerSuccessBlock)success
                    Failure:(CompletionHandlerFailureBlock)failure
               RequsetStart:(RequstStartBlock)requestStart
                ResponseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *request = [[HttpRequest alloc]initWithRequestWithName:name UrlString:url Parameters:parameters IsGET:isGet IsCache:isCache];
    [request startRequestWithSuccessBlock:success FailedBlock:failure RequsetStart:requestStart ResponseEnd:responseEnd];
    
}
@end
