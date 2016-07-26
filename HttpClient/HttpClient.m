//
//  HttpClient.m
//  AFNWorking3_0Demo
//
//  Created by admin on 16/5/12.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "HttpClient.h"
#import "NSMutableDictionary+Category.h"

#define HTTPURL @"http://test.3tichina.com:8023/aiya"
#define HTTPIMAGEURL @"http://show.3tichina.com:8002"

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

//普通请求接口测试
- (HttpRequest *)testApiWithnextPage:(NSString *)nextPage
                   pageSize:(NSString *)pageSize
                     status:(NSString *)status
                   sortData:(NSString *)sortData
                 jsonFilter:(NSString *)jsonFilter
                    success:(CompletionHandlerSuccessBlock)success
                             failure:(CompletionHandlerFailureBlock)failure
                        requsetStart:(RequstStartBlock)requestStart
                         responseEnd:(ResponseEndBlock)responseEnd{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addUnEmptyString:nextPage forKey:@"nextPage"];
    [parameters addUnEmptyString:pageSize forKey:@"pageSize"];
    [parameters addUnEmptyString:status forKey:@"status"];
    [parameters addUnEmptyString:sortData forKey:@"sortData"];
    [parameters addUnEmptyString:jsonFilter forKey:@"jsonFilter"];
    
    HttpRequest *request = [[HttpRequest alloc]init];
    
    [request requestWithrequestName:@"测试接口" URLString:[HTTPURL DoMainNameWithString:@"/m/doctor/findDoctorList"] parameters:parameters isPOST:YES];
    
    [request startRequsetWithSuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return request;
}

//上传请求接口测试
- (HttpRequest *)uploadPhotoWithPhotoFile:(NSArray *)PhotoFile
                                 progress:(UploadProgressBlock)progress
                         success:(CompletionHandlerSuccessBlock)success
                                  failure:(CompletionHandlerFailureBlock)failure
                             requsetStart:(RequstStartBlock)requestStart
                              responseEnd:(ResponseEndBlock)responseEnd {
  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    HttpRequest *uploadRequset = [[HttpRequest alloc]init];
    
    [uploadRequset uploadRequestWithrequestName:@"上传测试" URLString:[HTTPURL DoMainNameWithString:@"/m/userExtend/photoUpload"] parameters:parameters PhotoFile:PhotoFile isPOST:YES];
    
    [uploadRequset uploadStartRequsetWithUnitSize:UntiSizeIsKByte Progress:progress SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return uploadRequset;
}

//图片下载测试
- (HttpRequest *)downloadPhotoWithprogress:(UploadProgressBlock)progress
                               destination:(downloadDestinationBlock)destination
                                   success:(CompletionHandlerSuccessBlock)success
                                   failure:(CompletionHandlerFailureBlock)failure
                              requsetStart:(RequstStartBlock)requestStart
                               responseEnd:(ResponseEndBlock)responseEnd {
    
    HttpRequest *uploadRequset = [[HttpRequest alloc]init];
    
    [uploadRequset downloadRequestWithrequestName:@"下载测试" URLString:[HTTPIMAGEURL DoMainNameWithString:@"/aiyamis/original/upload/pics/2044/1/79/0_20160719110554.jpg"]];
    
    [uploadRequset downloadStartRequsetWithUnitSize:UntiSizeIsByte Progress:progress destination:destination SuccessBlock:^(HttpRequest *request, HttpResponse *response) {
        //可以在这里转模型数据传出去 付给response.sourceModel
        success(request,response);
    } FailedBlock:failure requsetStart:requestStart responseEnd:responseEnd];
    
    return uploadRequset;

}

@end
