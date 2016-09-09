//
//  HttpFileLoadProgress.h
//  XLAFNetworking
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 along. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 单位
 */
typedef NS_ENUM(NSInteger,UnitSize) {
    UntiSizeIsByte = 0,
    UntiSizeIsKByte,
    UntiSizeIsMByte,
    UntiSizeIsGByte
};

@interface HttpFileLoadProgress : NSObject

/**
 *  //加载值 默认单位b
 */
@property (nonatomic,assign,readwrite) float loadProgress;

/**
 *  加载大小 单位kb
 */
@property (nonatomic,assign,readwrite) float loadProgressKb;
/**
 *  加载大小 单位Mb
 */
@property (nonatomic,assign,readwrite) float loadProgressMb;
/**
 *  加载大小 单位Gb
 */
@property (nonatomic,assign,readwrite) float loadProgressGb;

/**
 *  //总大小 默认单位b
 */
@property (nonatomic,assign,readwrite) int64_t maxSize;

/**
 *  加载大小 单位kb
 */
@property (nonatomic,assign,readwrite) double maxSizeKb;
/**
 *  加载大小 单位Mb
 */
@property (nonatomic,assign,readwrite) double maxSizeMb;
/**
 *  加载大小 单位Gb
 */
@property (nonatomic,assign,readwrite) double maxSizeGb;
/**
 *  //加载百分比
 */
@property (nonatomic,assign,readwrite) double loadFractionCompleted;

/**
 *  初始化
 *
 *  @param unitSize 单位
 *
 *  @return self
 */
- (instancetype)initWithUnitSize:(UnitSize)unitSize;

@end
