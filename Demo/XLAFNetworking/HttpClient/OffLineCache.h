//
//  OffLineCache.h
//  XLAFNetworking
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "HttpResponse.h"

@interface OffLineCache : NSObject 
/**
 *  请求类型
 */
@property (nonatomic,strong) NSString *requestType;
/**
 *  请求名称
 */
@property (nonatomic,strong) NSString *requestName;
/**
 *  请求路径url
 */
@property (nonatomic,strong) NSString *requestPath;
/**
 *  请求参数
 */
@property (nonatomic,strong) NSData *requestParaters;
/**
 *  请求结果数据
 */
@property (nonatomic,strong) NSData *responseData;

/**
 *  创建离线缓存
 *
 *  @param request  请求
 *  @param response 响应
 */
- (void)createOffLineDataWithRequest:(HttpRequest *)request Response:(HttpResponse *)response;

/**
 *  获取缓存数据里的请求对象
 *
 *  @param requestPath url
 *
 *  @return request对象
 */
- (HttpRequest *)getRequestCacheWithRequestPath:(NSString *)requestPath;

/**
 *  获取缓存数据里的响应对象
 *
 *  @param requestPath url
 *
 *  @return response对象
 */
- (HttpResponse *)getResponseCacheWithRequestPath:(NSString *)requestPath;
@end
