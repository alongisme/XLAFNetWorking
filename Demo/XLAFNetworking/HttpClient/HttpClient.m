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

@implementation HttpClient

#pragma mark 单例

static HttpClient *httpClient = nil;
+ (id)sharedInstance {
    
    dispatch_once_t predicate = 0;
    
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
- (void)checkNetworkingStatus:(NetworingStautBlock)block {
    HttpRequest *requst = [[HttpRequest alloc]init];
    [requst checkNetworkingStatus:block];
}

- (HttpRequest *)requestApiWithHttpRequestMode:(HttpRequestMode *)requestMode
                           success:(CompletionHandlerSuccessBlock)success
                           failure:(CompletionHandlerFailureBlock)failure
                      requsetStart:(RequstStartBlock)requestStart
                       responseEnd:(ResponseEndBlock)responseEnd {
    
    return [self requestBaseWithName:requestMode.name url:requestMode.url parameters:requestMode.parameters isGET:requestMode.isGET success:^(HttpRequest *request, HttpResponse *response) {
        success(request,response);
    } failure:failure requsetStart:requestStart responseEnd:responseEnd];;
}

- (HttpRequest *)uploadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                 progress:(UploadProgressBlock)progress
                         success:(CompletionHandlerSuccessBlock)success
                                  failure:(CompletionHandlerFailureBlock)failure
                             requsetStart:(RequstStartBlock)requestStart
                              responseEnd:(ResponseEndBlock)responseEnd {
  
    HttpRequest *uploadRequset = [[HttpRequest alloc]init];
    
    [uploadRequset uploadRequestWithrequestName:requestMode.name URLString:requestMode.url parameters:requestMode.parameters PhotoFile:requestMode.uploadModels isGET:requestMode.isGET];
    
    [uploadRequset uploadStartRequsetWithUnitSize:UntiSizeIsKByte Progress:progress SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return uploadRequset;
}

- (HttpRequest *)downloadPhotoWithHttpRequestMode:(HttpRequestMode *)requestMode
                                         progress:(UploadProgressBlock)progress
                               destination:(downloadDestinationBlock)destination
                                   success:(CompletionHandlerSuccessBlock)success
                                   failure:(CompletionHandlerFailureBlock)failure
                              requsetStart:(RequstStartBlock)requestStart
                               responseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *uploadRequset = [[HttpRequest alloc]init];
    
    [uploadRequset downloadRequestWithrequestName:requestMode.name URLString:requestMode.url];
    
    [uploadRequset downloadStartRequsetWithUnitSize:UntiSizeIsByte Progress:progress destination:destination SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return uploadRequset;

}


//普通请求基类
- (HttpRequest *)requestBaseWithName:(NSString *)name url:(NSString *)url parameters:(NSDictionary *)parameters isGET:(BOOL)isGET success:(CompletionHandlerSuccessBlock)success
                             failure:(CompletionHandlerFailureBlock)failure
                        requsetStart:(RequstStartBlock)requestStart
                         responseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *request = [[HttpRequest alloc]init];
    
    [request requestWithrequestName:name URLString:url?url:@"" parameters:parameters isGET:isGET];
    
    [request startRequsetWithSuccessBlock:success FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return request;
    
}

@end
