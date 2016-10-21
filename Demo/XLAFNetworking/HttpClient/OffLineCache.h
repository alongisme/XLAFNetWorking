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
@property (nonatomic,strong,readwrite) NSString *requestType;
/**
 *  请求名称
 */
@property (nonatomic,strong,readwrite) NSString *requestName;
/**
 *  请求路径url
 */
@property (nonatomic,strong,readwrite) NSString *requestPath;
/**
 *  请求参数
 */
@property (nonatomic,strong,readwrite) NSData *requestParaters;
/**
 *  响应名称
 */
@property (nonatomic,strong,readwrite) NSString *responseName;
/**
 *  请求结果数据
 */
@property (nonatomic,strong,readwrite) NSData *responseData;

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
- (HttpRequest *)getRequestCacheWithHttpRequest:(HttpRequest *)httpRequest;

/**
 *  获取缓存数据里的响应对象
 *
 *  @param requestPath url
 *
 *  @return response对象
 */
- (HttpResponse *)getResponseCacheWithHttpRequest:(HttpRequest *)httpRequest;
@end
