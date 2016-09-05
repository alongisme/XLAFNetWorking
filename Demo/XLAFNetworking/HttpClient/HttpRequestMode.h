//
//  HttpRequestMode.h
//  XLAFNetworking
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadModel;
@class HttpRequestMode;

//block
typedef HttpRequestMode *(^CreateHttpRequestMode)(id requestParameters);

@interface HttpRequestMode : NSObject
/**
 *  命名
 */
@property (nonatomic,strong,readwrite) NSString *name;
/**
 *  接口
 */
@property (nonatomic,strong,readwrite) NSString *url;
/**
 *  参数
 */
@property (nonatomic,strong,readwrite) NSDictionary *parameters;
/**
 *  类型
 */
@property (nonatomic,assign,readwrite) BOOL isGET;
/**
 *  上传文件数组
 */
@property (nonatomic,strong,readwrite) NSArray<UploadModel *> *uploadModels;

/**
 *  设置命名
 *
 *  @return block
 */
- (CreateHttpRequestMode)SetName;

/**
 *  设置接口
 *
 *  @return block
 */
- (CreateHttpRequestMode)SetUrl;

/**
 *  设置参数
 *
 *  @return block
 */
- (CreateHttpRequestMode)SetParameters;

/**
 *  设置类型
 *
 *  @return block
 */
- (CreateHttpRequestMode)SetIsGET;

/**
 *  这只上传文件数组
 *
 *  @return block
 */
- (CreateHttpRequestMode)SetUploadModels;
@end
