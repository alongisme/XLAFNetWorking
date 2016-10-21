//
//  OffLineCache.m
//  XLAFNetworking
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "OffLineCache.h"
#import "JRDB.h"

static NSString *const ALKeyedArchiverWithParaDic = @"ALKeyedArchiverWithParaDic";
static NSString *const ALKeyedArchiverWithResultDic = @"ALKeyedArchiverWithResultDic";

@implementation OffLineCache

+ (void)initialize {
    //注册
    [[JRDBMgr shareInstance] registerClazz:[self class]];
    
    //不显示sql语句
    [[JRDBMgr shareInstance] setDebugMode:NO];
}

/**
 *  创建离线缓存
 *
 *  @param request  请求
 *  @param response 响应
 */
- (void)createOffLineDataWithRequest:(HttpRequest *)request Response:(HttpResponse *)response {
    NSArray<OffLineCache *> *result = J_Select(OffLineCache).Where([NSString stringWithFormat:@"_requestPath = '%@'",request.requestPath]).list;
    
    if(request && response) {
        
        if([result count] == 0) {
            [self setOffLineObjectDataWithObj:self Request:request Response:response];
            J_Insert(self).updateResult;
        }else {
            OffLineCache *offLineCache = [result lastObject];
            [self setOffLineObjectDataWithObj:offLineCache Request:request Response:response];
            J_Update(offLineCache).updateResult;
        }
        
    }

}

/**
 *  获取缓存数据里的请求对象
 *
 *  @param requestPath url
 *
 *  @return request对象
 */
- (HttpRequest *)getRequestCacheWithHttpRequest:(HttpRequest *)httpRequest {
    NSArray<OffLineCache *> *result = J_Select(OffLineCache).Where([NSString stringWithFormat:@"_requestPath = '%@'",httpRequest.requestPath]).list;
    
    HttpRequest *request = [[HttpRequest alloc]init];
    request.requestType = [result lastObject].requestType;
    request.requestName = [result lastObject].requestName;
    request.requestPath = [result lastObject].requestPath;
    
    request.params = [[self returnDictionaryWithLocaData:[result lastObject].requestParaters key:ALKeyedArchiverWithParaDic] mutableCopy];
    
    return request;
}

/**
 *  获取缓存数据里的响应对象
 *
 *  @param requestPath url
 *
 *  @return response对象
 */
- (HttpResponse *)getResponseCacheWithHttpRequest:(HttpRequest *)httpRequest{
    NSArray<OffLineCache *> *result = J_Select(OffLineCache).Where([NSString stringWithFormat:@"_requestPath = '%@'",httpRequest.requestPath]).list;
    
    HttpResponse *response = [[HttpResponse alloc]init];
    response.result = [self returnDictionaryWithLocaData:[result lastObject].responseData key:ALKeyedArchiverWithResultDic];
    
    return response;
}

//设置缓存数据
- (void)setOffLineObjectDataWithObj:(OffLineCache *)offLineCache Request:(HttpRequest *)request Response:(HttpResponse *)response {
    offLineCache.requestType = request.requestType;
    offLineCache.requestName = request.requestName;
    offLineCache.requestPath = request.requestPath;
    offLineCache.requestParaters = [self returnDataWithRequsetDic:request.params key:ALKeyedArchiverWithParaDic];
    offLineCache.responseName = [NSString stringWithFormat:@"%@缓存数据",request.requestName];
    offLineCache.responseData = [self returnDataWithRequsetDic:response.result key:ALKeyedArchiverWithResultDic];
}

- (NSDictionary *)returnDictionaryWithLocaData:(NSData *)localData key:(NSString *)key{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:localData];
    return [unarchiver decodeObjectForKey:key];
}

//字典转data
- (NSData *)returnDataWithRequsetDic:(NSDictionary *)params key:(NSString *)key{
    NSMutableData *arcData = [[NSMutableData alloc]init];
    NSKeyedArchiver *arc = [[NSKeyedArchiver alloc]initForWritingWithMutableData:arcData];
    [arc encodeObject:params forKey:key];
    [arc finishEncoding];
    
    return [arcData copy];
}

@end
