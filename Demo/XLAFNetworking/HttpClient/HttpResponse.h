//
//  HttpResponse.h
//  XLAFNetworking
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpError;

//错误提示
#define DATA_FORMAT_ERROR   @"数据格式错误"
#define NETWORK_UNABLE      @"网络状况异常"
#define REQUEST_FAILE       @"网络请求失败"
#define NETCONNECT_FAILE       @"无网络连接！"
#define NETCONNECTTIME_FAILE       @"网络连接超时，请稍后再试！"

@interface HttpResponse : NSObject

/**
 *  是否成功
 */
@property (nonatomic,assign)BOOL isSuccess;

/**
 *  响应名字
 */
@property (nonatomic,strong)NSString *responseName;

/**
 *  错误代码
 */
@property (nonatomic,strong)NSString *errorCode;

/**
 *  错误信息
 */
@property (nonatomic,strong)NSString *errorMsg;

/**
 *  未处理之前的数据
 */
@property (nonatomic,assign)NSDictionary *ObjectData;

/**
 *  结果数据
 */
@property (nonatomic,strong)NSDictionary *result;

/**
 *  可以存放处理后的模型数据
 */
@property (nonatomic,assign)id sourceModel;

/**
 *  错误
 */
@property (nonatomic,strong)HttpError *httpError;

/**
 *  响应返回数据处理
 *
 *  @param ObjectData 解析数据
 */
- (void)loadResopnseWithObjectData:(NSDictionary *)ObjectData;

@end
