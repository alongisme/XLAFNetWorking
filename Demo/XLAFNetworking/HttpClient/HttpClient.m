//
//  HttpClient.m
//  XLAFNetworking
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpClient.h"
#import "OffLineCache.h"

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
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsCache:NO Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];

}

- (void)requestApiCacheWithHttpRequestMode:(HttpRequestMode *)requestMode
                              Success:(CompletionHandlerSuccessBlock)success
                              Failure:(CompletionHandlerFailureBlock)failure
                         RequsetStart:(RequstStartBlock)requestStart
                          ResponseEnd:(ResponseEndBlock)responseEnd {
  
    [self setIsCache:YES];
    
    [self requestBaseWithName:requestMode.name Url:requestMode.url Parameters:requestMode.parameters IsCache:YES Success:success Failure:failure RequsetStart:requestStart ResponseEnd:responseEnd];
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
                    IsCache:(BOOL)isCache
                    Success:(CompletionHandlerSuccessBlock)success
                    Failure:(CompletionHandlerFailureBlock)failure
               RequsetStart:(RequstStartBlock)requestStart
                ResponseEnd:(ResponseEndBlock)responseEnd {
    
    typeof(self) weakself = self;
    
    if(requestStart) {
        requestStart();
    }
    
    HttpRequest *request = [HttpRequest new];
    
    [request setRequestName:name];
    [request setRequestPath:url];
    [request setRequestType:@"普通请求"];
    [request setParams:parameters];
    
    [self Log:request];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSMutableDictionary *responseData = [NSMutableDictionary dictionary];
        
        //判断是否是json数据
        if([NSJSONSerialization isValidJSONObject:responseObject]) {
            responseData = responseObject;
        }else {
            //转json
            @try {
                responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }
            @catch (NSException *exception) {
                [weakself Log:exception];//数据有问题
            }
            @finally {
                
            }
        }
        
        HttpResponse *response = [[HttpResponse alloc]init];
        response.responseName = name;
        [response loadResopnseWithObjectData:responseData];
        
        [weakself Log:response];
        
        if(response.isSuccess) {
            if(success) {
                //创建离线缓存
                if(isCache) {
                    [[OffLineCache new] createOffLineDataWithRequest:request Response:response];
                }
                success(request,response);
            }
        }else {
            if(failure) {
                failure(request,response);
            }
        }
        
        if(responseEnd) {
            responseEnd();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HttpError *httpError = [[HttpError alloc]init];
        [httpError handleHttpError:error];
        
        HttpResponse *response = [[HttpResponse alloc]init];
        response.responseName = request.requestName;
        response.objectData = [error userInfo];
        if([httpError.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]) {
            response.errorMsg = NETCONNECT_FAILE;
        }else {
            response.errorMsg = httpError.localizedDescription;
        }
        
        response.httpError = httpError;
        
        [weakself Log:response];
        [weakself Log:httpError];
        
        if(success && isCache) {
            //获取缓存数据
            [request getCacheDataWithSuccess:success];
        }
        
        if(failure) {
            failure(request,response);
        }
        
        if(responseEnd) {
            responseEnd();
        }
        
    }];
    
}

//打印消息
- (void)Log:(id)str {
#ifdef DEBUG
    if([HttpClient sharedInstance].debugMode) {
        DLOG(@"%@",str);
    }
#endif
}
@end
