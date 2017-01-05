//
//  HttpRequestMode.m
//  XLAFNetworking
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "HttpRequestMode.h"

@interface HttpRequestMode ()
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
 *  缓存
 */
@property (nonatomic,assign,readwrite) BOOL isCache;
/**
 *  类型
 */
@property (nonatomic,assign,readwrite) BOOL isGET;
/**
 *  header
 */
@property (nonatomic,strong,readwrite) NSDictionary *headDictionary;
/**
 *  上传文件数组
 */
@property (nonatomic,strong,readwrite) NSArray<UploadModel *> *uploadModels;
/**
 *  msgView
 */
@property (nonatomic,strong,readwrite) UIView *msgVIew;
@end

@implementation HttpRequestMode
- (CreateHttpRequestMode)SetName {
    return ^id(NSString *name) {
        if([name isKindOfClass:[NSString class]]) {
            _name = name;
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetUrl {
    return ^id(NSString *url) {
        if([url isKindOfClass:[NSString class]]) {
            _url = url;
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetParameters {
    return ^id(NSDictionary *Parameters) {
        if([Parameters isKindOfClass:[NSDictionary class]]) {
            _parameters = Parameters;
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetIsCache {
    return ^id(NSNumber *isCache) {
        if([isCache isKindOfClass:[NSNumber class]]) {
            _isCache = [isCache boolValue];
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetIsGET {
    return ^id(NSNumber *isGET) {
        if([isGET isKindOfClass:[NSNumber class]]) {
            _isGET = [isGET boolValue];
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetHeaderValue {
    return ^id(NSDictionary *headDic) {
        if([headDic isKindOfClass:[NSDictionary class]]) {
            _headDictionary = headDic;
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetUploadModels {
    return ^id(NSArray<UploadModel *> *uploadModels) {
        if([uploadModels isKindOfClass:[NSArray class]]) {
            _uploadModels = uploadModels;
        }
        return self;
    };
}

- (CreateHttpRequestMode)SetMsgView {
    return ^id(UIView *view) {
        if([view isKindOfClass:[UIView class]]) {
            _msgVIew = view;
        }
        return self;
    };
}

- (void)complete {
    if(self.Complete) {
        self.Complete();
    }
}
@end
