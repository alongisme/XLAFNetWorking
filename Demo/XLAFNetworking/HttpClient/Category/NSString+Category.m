//
//  NSString+Category.m
//  AFNWorking3_0Demo
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (NSString_Category)
/**
 *  判断一个字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return 返回结果
 */
+ (BOOL)checkIsStringEmpty:(NSString *)string {
    if(string == nil) {
        return YES;
    }
    
    if(string.length == 0) {
        return YES;
    }
    
    if([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}

/**
 *  域名拼接
 *
 *  @param DoMainName 域名
 *  @param string     拼接的字符串
 *
 *  @return 返回拼接后的字符串
 */
+ (NSString *)URLstringFromatWithDoMainName:(NSString *)DoMainName string:(NSString *)string {
    return [self stringWithFormat:@"%@/%@",DoMainName,string];
}

/**
 *  域名拼接
 *
 *  @param string 拼接的字符串
 *
 *  @return 返回拼接后的字符串
 */
- (NSString *)DoMainNameWithString:(NSString *)string {
    return [self stringByAppendingPathComponent:string];
}
@end
