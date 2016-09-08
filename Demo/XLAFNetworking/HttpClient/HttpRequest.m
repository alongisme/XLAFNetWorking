//
//  HttpRequest.m
//  XLAFNetworking
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpRequest.h"
#import "UploadModel.h"
#import "OffLineCache.h"

@interface HttpRequest () {
    CFAbsoluteTime startTime;//记录请求开始的时候
}
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;//数据任务
@property (nonatomic,strong) NSURLSessionUploadTask *uploadTask;//上传任务
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;//下载任务
@end

@implementation HttpRequest

#pragma mark init 初始化
-(instancetype)init {
    if(self = [super init]) {
        //请求格式 //统一只使用二进制
        _requestSerializer = [AFHTTPRequestSerializer serializer];
       }
    return self;
}

#pragma mark 判断网络状态
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
                    block(1);
                }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //WiFi
                if(block) {
                    block(2);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //无线连接
                if(block) {
                    block(3);
                }
                break;
            case AFNetworkReachabilityStatusUnknown:
                //未知
                if(block) {
                    block(4);
                }
                break;
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark POST-GET请求
/**
 *  创建请求
 *
 *  @param requestName 请求名字
 *  @param URLString   请求路径
 *  @param parameters  请求参数
 *  @param isPOST      是否POST
 *
 *  @return HttpRequest
 */
- (HttpRequest *)requestWithrequestName:(NSString *)requestName
                     URLString:(NSString *)URLString
                    parameters:(id)parameters
                        isGET:(BOOL)isGET {
    
    NSMutableURLRequest *request = [_requestSerializer requestWithMethod:isGET?@"GET":@"POST" URLString:URLString parameters:parameters error:nil];
    
    //设置请求的显示信息
    [self setRequsetDisplayInfoWithrequestType:[self getRequestTypeWithrequestType:NormalTask] requestName:requestName requestPath:URLString parameters:parameters urlRequest:request];
    
    DLOG(@"%@",self);

    return self;
}

/**
 *  开始请求
 *
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  响应结束回调
 */
- (void)startRequsetWithSuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                         FailedBlock:(CompletionHandlerFailureBlock)failedBlock
                        requsetStart:(RequstStartBlock)requestStart
                         responseEnd:(ResponseEndBlock)responseEnd {
    
    //记录请求开始时间
    startTime = CFAbsoluteTimeGetCurrent();
    
    //请求开始
    if(requestStart) {
        requestStart();
    }
    
    //结束回调
    if(responseEnd) {
        _endBlock = responseEnd;
    }
    
    __weak typeof(self) weakSelf = self;
    
    _dataTask = [[AFHTTPSessionManager manager]dataTaskWithRequest:_urlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if(error) {
            //有错误
            [weakSelf handleRequestErrorWitherror:error FailedBlock:failedBlock];
        }else {
            //无错误
            [weakSelf handleSuccessBlockDataWithresponseObject:responseObject SuccessBlock:successBlock FailedBlock:failedBlock];
        }
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
        
    }];
        
    [_dataTask resume];
    
}

#pragma mark 上传任务
/**
 *  上传文件任务请求
 *
 *  @param requestName 请求名字
 *  @param URLString   请求路径
 *  @param parameters  请求参数
 *  @param PhotoFile   文件数据
 *  @param isPOST      是否POST
 *
 *  @return HttpRequest
 */
- (HttpRequest *)uploadRequestWithrequestName:(NSString *)requestName URLString:(NSString *)URLString parameters:(id)parameters PhotoFile:(NSArray *)PhotoFile isGET:(BOOL)isGET {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:isGET?@"GET":@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (id imageModel in PhotoFile) {
            if([imageModel isKindOfClass:[UploadModel class]]) {
                
                UploadModel *uploadModel = imageModel;
                
                [formData appendPartWithFileData:uploadModel.fileData name:uploadModel.name fileName:uploadModel.fileName mimeType:uploadModel.mimeType];
            }
            
        }
        
    } error:nil];
    
    //设置请求的显示信息
    [self setRequsetDisplayInfoWithrequestType:[self getRequestTypeWithrequestType:UploadTask] requestName:requestName requestPath:URLString parameters:parameters urlRequest:request];
    
    DLOG(@"%@",self);
    
    return self;
}

/**
 *  上传任务开始请求
 *
 *  @param Progress     进度条回调
 *  @param unitSize     单位大小
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  响应结束回调
 */
- (void)uploadStartRequsetWithUnitSize:(UnitSize)unitSize
                              Progress:(UploadProgressBlock)Progress
                          SuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                           FailedBlock:(CompletionHandlerFailureBlock)failedBlock
                          requsetStart:(RequstStartBlock)requestStart
                           responseEnd:(ResponseEndBlock)responseEnd {
    
    //记录请求开始时间
    startTime = CFAbsoluteTimeGetCurrent();
    
    //请求开始
    if(requestStart) {
        requestStart();
    }
    
    //结束回调
    if(responseEnd) {
        _endBlock = responseEnd;
    }
    
    //创建管理者
    AFURLSessionManager *mamager = [[AFURLSessionManager alloc]initWithSessionConfiguration:_configuration?_configuration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //进度条数据
    __block HttpFileLoadProgress *httpFileLoadProgress = [[HttpFileLoadProgress alloc]initWithUnitSize:unitSize];
    
    _uploadTask = [mamager uploadTaskWithStreamedRequest:_urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(Progress) {
            //进度
            httpFileLoadProgress.loadProgress = uploadProgress.completedUnitCount;
            
            httpFileLoadProgress.maxSize = uploadProgress.totalUnitCount;
            
            httpFileLoadProgress.loadFractionCompleted = uploadProgress.fractionCompleted;
            
            Progress(httpFileLoadProgress);
            
            DLOG(@"%@",httpFileLoadProgress);
        }
        

        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error) {
            [self handleRequestErrorWitherror:error FailedBlock:failedBlock];
        }else {
            [self handleSuccessBlockDataWithresponseObject:responseObject SuccessBlock:successBlock FailedBlock:failedBlock];
        }
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
    }];
    
    [_uploadTask resume];
}

#pragma mark 下载任务
/**
 *  下载任务
 *
 *  @param requestName 请求名字
 *  @param URLString   请求路径
 *
 *  @return HttpRequest
 */
- (HttpRequest *)downloadRequestWithrequestName:(NSString *)requestName URLString:(NSString *)URLString {
    
    //设置请求的显示信息
    [self setRequsetDisplayInfoWithrequestType:[self getRequestTypeWithrequestType:DownloadTask] requestName:requestName requestPath:URLString parameters:nil urlRequest:[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URLString]]];
    
    DLOG(@"%@",self);
    
    return self;
}

/**
 *  下载任务
 *
 *  @param unitSize     单位大小
 *  @param Progress     进度条
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 *  @param requestStart 请求开始回调
 *  @param responseEnd  响应结束回调
 */
- (void)downloadStartRequsetWithUnitSize:(UnitSize)unitSize
                                         Progress:(UploadProgressBlock)Progress
                                      destination:(downloadDestinationBlock)destination
                                     SuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                                      FailedBlock:(CompletionHandlerFailureBlock)failedBlock
                                     requsetStart:(RequstStartBlock)requestStart
                                      responseEnd:(ResponseEndBlock)responseEnd {
    
    //记录请求开始时间
    startTime = CFAbsoluteTimeGetCurrent();
    
    //请求开始
    if(requestStart) {
        requestStart();
    }
    
    //结束回调
    if(responseEnd) {
        _endBlock = responseEnd;
    }
        
    //创建管理者
    AFURLSessionManager *mamager = [[AFURLSessionManager alloc]initWithSessionConfiguration:_configuration?_configuration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //进度条数据
    __block HttpFileLoadProgress *httpFileLoadProgress = [[HttpFileLoadProgress alloc]initWithUnitSize:unitSize];
    
    _downloadTask = [mamager downloadTaskWithRequest:_urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if(Progress) {
            httpFileLoadProgress.loadProgress = downloadProgress.completedUnitCount;
            
            httpFileLoadProgress.maxSize = downloadProgress.totalUnitCount;
            
            httpFileLoadProgress.loadFractionCompleted = downloadProgress.fractionCompleted;
            
            Progress(httpFileLoadProgress);
            
            DLOG(@"%@",httpFileLoadProgress);
        }
        

        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
    
        if(destination) {
            return destination(targetPath,response);
        }else {
    
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            NSURL *UrlPath = [NSURL fileURLWithPath:[cachesPath stringByAppendingPathComponent:response.suggestedFilename]];
            
            return UrlPath;
        }
        
                
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //设置下载完成操作
        
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        if(error) {
            [self handleRequestErrorWitherror:error FailedBlock:failedBlock];
        }else {
            [self handleDownloadSuccessBlockDataWithdownloadResponse:response filePath:filePath SuccessBlock:successBlock FailedBlock:failedBlock];
        }
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
        
    }];

    [_downloadTask resume];
    
}

#pragma mark 请求信息设置
/**
 *  设置请求的显示信息
 *
 *  @param requestType 类型
 *  @param requestName 名称
 *  @param requestPath 路径
 *  @param parameters 参数
 *  @param urlRequest  url
 */
- (void)setRequsetDisplayInfoWithrequestType:(NSString *)requestType requestName:(NSString *)requestName requestPath:(NSString *)requestPath parameters:(NSMutableDictionary *)parameters urlRequest:(NSMutableURLRequest *)urlRequest {
    
    _requestType = requestType;
    
    _requestName = requestName;
    
    _requestPath = requestPath;
    
    _params = parameters;
    
    _urlRequest = urlRequest;
    
    if(_timeoutInterval == 0) {
        _timeoutInterval = TIMEOUTINTERVAL;
    }
    
}

#pragma mark response处理
/**
 *  处理请求成功获得的数据
 *
 *  @param responseObject 返回的数据
 *  @param successBlock   成功回调
 *  @param failedBlock    失败回调
 */
- (void)handleSuccessBlockDataWithresponseObject:(id _Nullable)responseObject
                              SuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                               FailedBlock:(CompletionHandlerFailureBlock)failedBlock{
    
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
            DLOG(@"%@",exception);//数据有问题
        }
        @finally {
            
        }
    }
    
    //响应数据处理
    HttpResponse *response = [[HttpResponse alloc]init];
    response.responseName = [NSString stringWithFormat:@"%@响应",_requestName];
    [response loadResopnseWithObjectData:responseData];
    
    DLOG(@"%@",response);
    DLOG(@"\n========================Use Time: %lf ==========================\n", CFAbsoluteTimeGetCurrent() - startTime);

    //判断服务器是否返回成功
    if(response.isSuccess) {
        if(successBlock) {
            //创建离线缓存
            [[OffLineCache new] createOffLineDataWithRequest:self Response:response];
            successBlock(self,response);
        }
    }else {
        if(failedBlock) {
            failedBlock(self,response);
        }
    }
}

/**
 *  处理下载任务成功响应
 *
 *  @param downloadResponse 响应
 *  @param filePath         文件路径
 *  @param successBlock     成功回调
 *  @param failedBlock      失败回调
 */
- (void)handleDownloadSuccessBlockDataWithdownloadResponse:(NSURLResponse *)downloadResponse
                                          filePath:(NSURL *)filePath
                                    SuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                                     FailedBlock:(CompletionHandlerFailureBlock)failedBlock{
    
    
    //响应数据处理
    HttpResponse *response = [[HttpResponse alloc]init];
    
    response.responseName = [NSString stringWithFormat:@"%@响应",_requestName];
    
    response.result = @{@"file path is":filePath?filePath:@"nil"};
    
    DLOG(@"%@",response);
    DLOG(@"\n========================Use Time: %lf ==========================\n", CFAbsoluteTimeGetCurrent() - startTime);
    
    if(successBlock) {
        successBlock(self,response);
    }
}

/**
 *  处理请求错误
 *
 *  @param error        错误
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 */
- (void)handleRequestErrorWitherror:(NSError  * _Nullable )error
                        FailedBlock:(CompletionHandlerFailureBlock)failedBlock {
    
    HttpError *httpError = [[HttpError alloc]init];
    httpError.responseName = [NSString stringWithFormat:@"%@响应",_requestName];
    [httpError handleHttpError:error];

    HttpResponse *response = [[HttpResponse alloc]init];
    response.objectData = [error userInfo];
    response.errorMsg = httpError.localizedDescription;
    response.httpError = httpError;
    
    if(failedBlock) {
        failedBlock(self,response);
    }
    
    DLOG(@"%@",httpError);
    DLOG(@"\n========================Use Time: %lf ==========================\n", CFAbsoluteTimeGetCurrent() - startTime);
}

/**
 *  枚举替换
 *
 *  @param requestType 枚举值
 *
 *  @return 返回对应字符
 */
- (NSString *)getRequestTypeWithrequestType:(RequstType)requestType {
    switch (requestType) {
        case 0: {
            return @"普通请求";
        }
            break;
        case 1: {
            return @"上传请求";
        }
            break;
        case 2: {
            return @"下载请求";
        }
            break;
        default:
            return @"未知";
            break;
    }
}

#pragma mark 缓存
/**
 *  获取缓存数据
 */
- (void)getCacheDataWithRequestPath:(NSString *)requestPath Success:(CompletionHandlerSuccessBlock)success {
    if(success) {
        OffLineCache *offLineCache = [[OffLineCache alloc]init];
        success([offLineCache getRequestCacheWithRequestPath:requestPath],[offLineCache getResponseCacheWithRequestPath:requestPath]);
    }
}


#pragma mark 取消任务
/**
 *  取消请求
 */
- (void)cannel {

    if(_dataTask) {
        [_dataTask cancel];
        _dataTask = nil;
    }
    
    if(_uploadTask) {
        [_uploadTask cancel];
        _uploadTask = nil;
    }
    
    if(_downloadTask) {
        [_downloadTask cancel];
        _downloadTask = nil;
    }
    
    if(_endBlock) {
        _endBlock();
    }
    
}

#pragma mark setProperty
- (void)setRequestName:(NSString *)requestName {
    if(![requestName isEqualToString:@""] && requestName) {
        _requestName = requestName;
    }else {
        _requestName = @"无";
    }
}

- (void)setRequestPath:(NSString *)requestPath {
    if(![requestPath isEqualToString:@""] && requestPath) {
        _requestPath = requestPath;
    }else {
        _requestPath = @"无";
    }
}

#pragma mark description

-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Request Info==========================\n"];
    [descripString appendFormat:@"Request Type:%@\n",_requestType];
    [descripString appendFormat:@"Request Name:%@\n",_requestName];
    [descripString appendFormat:@"Request Url:%@\n",_requestPath];
    [descripString appendFormat:@"Request Methods:%@\n",[_urlRequest HTTPMethod]];
    [descripString appendFormat:@"Request params:\n%@\n",_params?_params:@"无"];
    [descripString appendFormat:@"Request header:\n%@\n",[_urlRequest allHTTPHeaderFields]?[_urlRequest allHTTPHeaderFields]:@"无"];
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}

@end
