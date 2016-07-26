//
//  UploadModel.h
//  AFNWorking3_0Demo
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadModel : NSObject
/**
 *  文件数据
 */
@property (nonatomic,strong)id fileData;
/**
 *  参数名称
 */
@property (nonatomic,strong)NSString *name;
/**
 *  文件名字
 */
@property (nonatomic,strong)NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic,strong)NSString *mimeType;

/**
 *  初始化一个上传文件模型并复制(对象方法)
 *
 *  @param fileData 文件数据
 *  @param name     参数名称
 *  @param fileName 文件名字
 *  @param mimeType 文件类型
 *
 *  @return obj
 */
- (instancetype)initWithUploadModelfileData:(id)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

/**
 *  初始化一个上传文件模型并复制(实例方法)
 *
 *  @param fileData 文件数据
 *  @param name     参数名称
 *  @param fileName 文件名字
 *  @param mimeType 文件类型
 *
 *  @return obj
 */
+ (instancetype)UploadModelWithfileData:(id)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
@end
