//
//  HttpResponse.m
//  XLAFNetworking
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpResponse.h"

@implementation HttpResponse

#pragma mark 响应返回数据处理

/**
 *  响应返回数据处理
 *
 *  @param ObjectData 解析数据
 */
- (void)loadResopnseWithObjectData:(NSDictionary *)ObjectData {
    
    self.ObjectData = ObjectData;
    
    //数据解析
    
    self.isSuccess = NO;
    
    if(ObjectData == nil) {
        self.errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    if ([[[ObjectData objectForKey:@"code"] stringValue] isEqualToString:@"1"]) {
        _isSuccess = YES;
    }else{
        self.errorCode = [ObjectData objectForKey:@"code"];
        _isSuccess = NO;
    }
    
    if (_isSuccess == NO && [ObjectData objectForKey:@"message"] == nil ) {
        self.errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    if (_isSuccess == YES && [ObjectData objectForKey:@"object"] == nil) {
        self.errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    if(_isSuccess == NO && [ObjectData objectForKey:@"message"]) {
        self.errorMsg = [ObjectData objectForKey:@"message"];
        return;
    }
    
    NSDictionary *result = [ObjectData objectForKey:@"object"];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        _isSuccess = YES;
        self.result = result;
    }
    else if ([result isKindOfClass:[NSArray class]]){
        _isSuccess = YES;
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"object"];
    }else if(result != nil){
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"object"];
    }
    else{
        _isSuccess = NO;
        self.errorMsg = DATA_FORMAT_ERROR;
    }

    
}

#pragma mark setProperty
- (void)setResponseName:(NSString *)responseName {
    if(![responseName isEqualToString:@""] && responseName) {
        _responseName = responseName;
    }else {
        _responseName = @"";
    }
}

- (void)setErrorCode:(NSString *)errorCode {
    if(![errorCode isEqualToString:@""] && errorCode) {
        _errorCode = errorCode;
    }else {
        _errorCode = @"无";
    }
}

- (void)setErrorMsg:(NSString *)errorMsg {
    if(![errorMsg isEqualToString:@""] && errorMsg) {
        _errorMsg = errorMsg;
    }else {
        _errorMsg = @"无";
    }
}

#pragma mark description
-(NSString *)description{
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Response Info===========================\n"];
    [descripString appendFormat:@"Response Name:%@\n",self.responseName];
    [descripString appendFormat:@"Response Content:\n%@\n",self.result];
    if(self.result == nil && self.isSuccess == NO) {
        [descripString appendFormat:@"Response Error:\n%@\n",self.errorMsg];
    }
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}
@end
