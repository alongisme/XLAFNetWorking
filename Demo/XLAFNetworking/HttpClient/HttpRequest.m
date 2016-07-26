//
//  HttpRequest.m
//  XLAFNetworking
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpRequest.h"
#import "UploadModel.h"

@interface HttpRequest () {
    CFAbsoluteTime startTime;//记录请求开始的时候
}
@property (nonatomic,strong)NSURLSessionDataTask *dataTask;//数据任务
@property (nonatomic,strong)NSURLSessionUploadTask *uploadTask;//上传任务
@property (nonatomic,strong)NSURLSessionDownloadTask *downloadTask;//下载任务
@end

@implementation HttpRequest

#pragma mark init 初始化
-(instancetype)init {
    if(self == [super init]) {
        //请求格式 //统一只使用二进制
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
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
- (void)checkNetworkingStatus:(NetworingStautBlock)block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                //网络不通
                block(1);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //WiFi
                block(2);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //无线连接
                block(3);
                break;
            case AFNetworkReachabilityStatusUnknown:
                //未知
                block(4);
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
                        isPOST:(BOOL)isPOST {
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:isPOST?@"POST":@"GET" URLString:URLString parameters:parameters error:nil];
    
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
    requestStart();
    
    //结束回调
    self.endBlock = responseEnd;
    
    __block HttpRequest *BlockSelf = self;
    
    self.dataTask = [[AFHTTPSessionManager manager]dataTaskWithRequest:self.urlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
        
        if(error) {
            //有错误
            [BlockSelf handleRequestErrorWitherror:error SuccessBlock:nil FailedBlock:failedBlock];
        }else {
            //无错误
            [BlockSelf handleSuccessBlockDataWithresponseObject:responseObject SuccessBlock:successBlock FailedBlock:failedBlock];
        }
    }];
        
    [self.dataTask resume];
    
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
- (HttpRequest *)uploadRequestWithrequestName:(NSString *)requestName URLString:(NSString *)URLString parameters:(id)parameters PhotoFile:(NSArray *)PhotoFile isPOST:(BOOL)isPOST {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:isPOST?@"POST":@"GET" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
    requestStart();
    
    //结束回调
    self.endBlock = responseEnd;
    
    //创建管理者
    AFURLSessionManager *mamager = [[AFURLSessionManager alloc]initWithSessionConfiguration:self.configuration?_configuration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //进度条数据
    HttpFileLoadProgress *httpFileLoadProgress = [[HttpFileLoadProgress alloc]initWithUnitSize:unitSize];
    
    __block HttpRequest *BlockSelf = self;
    
    __block HttpFileLoadProgress *BlockProgressInfo = httpFileLoadProgress;
    
    self.uploadTask = [mamager uploadTaskWithStreamedRequest:self.urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度
        
        BlockProgressInfo.loadProgress = uploadProgress.completedUnitCount;
        
        BlockProgressInfo.maxSize = uploadProgress.totalUnitCount;
        
        BlockProgressInfo.loadFractionCompleted = uploadProgress.fractionCompleted;
        
        Progress(httpFileLoadProgress);

        DLOG(@"%@",httpFileLoadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
        
        if(error) {
            [BlockSelf handleRequestErrorWitherror:error SuccessBlock:nil FailedBlock:failedBlock];
        }else {
            [BlockSelf handleSuccessBlockDataWithresponseObject:responseObject SuccessBlock:successBlock FailedBlock:failedBlock];
        }
        
    }];
    
    [self.uploadTask resume];
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
    requestStart();
    
    //结束回调
    self.endBlock = responseEnd;
    
    //创建管理者
    AFURLSessionManager *mamager = [[AFURLSessionManager alloc]initWithSessionConfiguration:self.configuration?_configuration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //进度条数据
    HttpFileLoadProgress *httpFileLoadProgress = [[HttpFileLoadProgress alloc]initWithUnitSize:unitSize];
    
    __block HttpRequest *BlockSelf = self;
    
    __block HttpFileLoadProgress *BlockProgressInfo = httpFileLoadProgress;
    
    self.downloadTask = [mamager downloadTaskWithRequest:self.urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        BlockProgressInfo.loadProgress = downloadProgress.completedUnitCount;
        
        BlockProgressInfo.maxSize = downloadProgress.totalUnitCount;
        
        BlockProgressInfo.loadFractionCompleted = downloadProgress.fractionCompleted;
        
        Progress(httpFileLoadProgress);
        
        DLOG(@"%@",httpFileLoadProgress);
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSURL *UrlPath = [NSURL fileURLWithPath:[cachesPath stringByAppendingPathComponent:response.suggestedFilename]];
        
        return (destination(targetPath,response))?(destination(targetPath,response)):UrlPath;
                
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //设置下载完成操作
        
        //响应结束
        if(responseEnd) {
            responseEnd();
        }
        
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        if(error) {
            [BlockSelf handleRequestErrorWitherror:error SuccessBlock:nil FailedBlock:failedBlock];
        }else {
            [BlockSelf handleDownloadSuccessBlockDataWithdownloadResponse:response filePath:filePath SuccessBlock:successBlock FailedBlock:failedBlock];
        }
        
        
    }];

    [self.downloadTask resume];
    
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
    
    self.requestType = requestType;
    
    self.requestName = requestName;
    
    self.requestPath = requestPath;
    
    self.params = parameters;
    
    self.urlRequest = urlRequest;
    
    (_timeoutInterval != 0 )?([urlRequest setTimeoutInterval:_timeoutInterval]):([urlRequest setTimeoutInterval:TIMEOUTINTERVAL]);
    
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
    response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
    [response loadResopnseWithObjectData:responseData];
    
    DLOG(@"%@",response);
    DLOG(@"\n========================Use Time: %lf ==========================\n", CFAbsoluteTimeGetCurrent() - startTime);
    
    //判断服务器是否返回成功
    if(response.isSuccess) {
        successBlock(self,response);
    }else {
        failedBlock(self,response);
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
    
    response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
    
    response.result = @{@"file path is":filePath};
    
    DLOG(@"%@",response);
    DLOG(@"\n========================Use Time: %lf ==========================\n", CFAbsoluteTimeGetCurrent() - startTime);
    
    successBlock(self,response);

}

/**
 *  处理请求错误
 *
 *  @param error        错误
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 */
- (void)handleRequestErrorWitherror:(NSError  * _Nullable )error
                       SuccessBlock:(CompletionHandlerSuccessBlock)successBlock
                        FailedBlock:(CompletionHandlerFailureBlock)failedBlock {
    
    HttpError *httpError = [[HttpError alloc]init];
    [httpError handleHttpError:error];
    
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
    
    if(self.endBlock) {
        self.endBlock();
    }
    
}

#pragma mark description

-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Request Info==========================\n"];
    [descripString appendFormat:@"Request Type:%@\n",self.requestType];
    [descripString appendFormat:@"Request Name:%@\n",self.requestName];
    [descripString appendFormat:@"Request Url:%@\n",self.requestPath];
    [descripString appendFormat:@"Request Methods:%@\n",[self.urlRequest HTTPMethod]];
    [descripString appendFormat:@"Request params:\n%@\n",self.params];
    [descripString appendFormat:@"Request header:\n%@\n",[self.urlRequest allHTTPHeaderFields]];
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}

@end
