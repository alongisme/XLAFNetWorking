//
//  NSObject+ALFormat.m
//  XLAFNetworking
//
//  Created by aaa on 16/8/2.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "NSObject+ALFormat.h"

@implementation NSObject(NSObject_ALFormat)
/**
 *  将基本格式对象格式化为NSString
 *  @return 格式化后的对象
 */
- (NSString *)FormatObject {
    if([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    if([self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",self];
    }
    
    return nil;
}
@end
