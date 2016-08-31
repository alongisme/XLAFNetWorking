//
//  HttpRequestMode.h
//  XLAFNetworking
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadModel;

@interface HttpRequestMode : NSObject
@property (nonatomic,copy,readwrite) NSString *name;
@property (nonatomic,copy,readwrite) NSString *url;
@property (nonatomic,copy,readwrite) NSDictionary *parameters;
@property (nonatomic,assign,readwrite) BOOL isPost;
@property (nonatomic,copy,readwrite) NSArray<UploadModel *> *uploadModels;
@end
