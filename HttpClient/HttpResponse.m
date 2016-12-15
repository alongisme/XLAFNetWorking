//
//  HttpResponse.m
//  XLAFNetworking
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 along. All rights reserved.
//

#import "HttpResponse.h"

@interface HttpResponse ()
@property (nonatomic,assign,readwrite) NSUInteger resultNumber;
@end

@implementation HttpResponse

#pragma mark 响应返回数据处理

/**
 *  响应返回数据处理
 *
 *  @param ObjectData 解析数据
 */
- (void)loadResopnseWithObjectData:(NSDictionary *)objectData {
        
    _objectData = objectData;
    
    //数据解析
    
    _isSuccess = NO;
    
    if(objectData == nil) {
        _errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    NSString *code = [self checkString:objectData[@"code"]];
    NSString *message = [self checkString:objectData[@"message"]];
    id object = objectData[@"object"];
    
    if ([code isEqualToString:@"1"]) {
        _isSuccess = YES;
    }else{
        _errorCode = code;
        _isSuccess = NO;
    }
    
    if (_isSuccess == NO && message == nil ) {
        _errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    if (_isSuccess == YES && object == nil) {
        _errorMsg = DATA_FORMAT_ERROR;
        return;
    }
    
    if(_isSuccess == NO && message) {
        _errorMsg = message;
        return;
    }
    
    NSDictionary *result = object;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        _isSuccess = YES;
        _result = result;
    }
    else if ([result isKindOfClass:[NSArray class]]){
        _isSuccess = YES;
        _result = [NSDictionary dictionaryWithObject:result forKey:@"object"];
    }else if(result != nil){
        _result = [NSDictionary dictionaryWithObject:result forKey:@"object"];
    }
    else{
        _isSuccess = NO;
        _errorMsg = DATA_FORMAT_ERROR;
    }
    
    _resultNumber = [result count];
}

- (NSString *)checkString:(id)str {
    if([str isKindOfClass:[NSString class]]) {
        return str;
    } else {
        return [str stringValue];
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
    [descripString appendFormat:@"Response Name:%@\n",_responseName];
    [descripString appendFormat:@"Response Content(%lu 条数据):\n%@\n",_resultNumber,_result];
    if(_result == nil && _isSuccess == NO) {
        [descripString appendFormat:@"Response Error:\n%@\n",_errorMsg];
    }
    [descripString appendString:@"===============================================================\n"];
    return descripString;
}
@end
