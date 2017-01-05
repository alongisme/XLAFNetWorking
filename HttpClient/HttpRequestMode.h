//
//  HttpRequestMode.h
//  XLAFNetworking
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UploadModel;
@class HttpRequestMode;

//block
typedef HttpRequestMode *(^CreateHttpRequestMode)(id requestParameters);

@interface HttpRequestMode : NSObject
/**
 *  命名
 */
@property (nonatomic,strong,readonly) NSString *name;
/**
 *  接口
 */
@property (nonatomic,strong,readonly) NSString *url;
/**
 *  参数
 */
@property (nonatomic,strong,readonly) NSDictionary *parameters;
/**
 *  缓存
 */
@property (nonatomic,assign,readonly) BOOL isCache;
/**
 *  类型
 */
@property (nonatomic,assign,readonly) BOOL isGET;
/**
 *  header
 */
@property (nonatomic,strong,readonly) NSDictionary *headDictionary;
/**
 *  上传文件数组
 */
@property (nonatomic,strong,readonly) NSArray<UploadModel *> *uploadModels;
/**
 *  msgView
 */
@property (nonatomic,strong,readonly) UIView *msgVIew;
/**
 *  完成回调通知
 */
@property (nonatomic,strong) void (^Complete)();

/**
 * 设置参数
 */
- (CreateHttpRequestMode)SetName;
- (CreateHttpRequestMode)SetUrl;
- (CreateHttpRequestMode)SetParameters;
- (CreateHttpRequestMode)SetIsCache;
- (CreateHttpRequestMode)SetIsGET;
- (CreateHttpRequestMode)SetHeaderValue;
- (CreateHttpRequestMode)SetUploadModels;
/**
 * 完成回调
 */
- (void)complete;
@end
