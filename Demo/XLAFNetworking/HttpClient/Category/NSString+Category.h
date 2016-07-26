//
//  NSString+Category.h
//  AFNWorking3_0Demo
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Category)
/**
 *  判断一个字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return 返回结果
 */
+ (BOOL)checkIsStringEmpty:(NSString *)string;

/**
 *  域名拼接
 *
 *  @param DoMainName 域名
 *  @param string     拼接的字符串
 *
 *  @return 返回拼接后的字符串
 */
+ (NSString *)URLstringFromatWithDoMainName:(NSString *)DoMainName string:(NSString *)string;

/**
 *  域名拼接
 *
 *  @param string 拼接的字符串
 *
 *  @return 返回拼接后的字符串
 */
- (NSString *)DoMainNameWithString:(NSString *)string;

/**
 *  字符串反转函数
 *
 *  @param String 传入的字符串
 *
 *  @return 逆序后的字符串
 */
+ (NSString *)ReverserWithString:(NSString *)String;

/**
 *  判断是不是手机号
 *
 *  @param String  要判断的字符串
 *
 *  @return 返回yes或no
 */
+ (BOOL)isPhoneNumberWithString:(NSString *)String;

/**
 *  MD5加密
 *
 *  @param String 要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)md5WithString:(NSString *)String;

/**
 *  base64加密
 *
 *  @param text 要加密的字符串
 *
 *  @return 返回加密的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 *  base64解密
 *
 *  @param base64 密文
 *
 *  @return 返回解密后的字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

/**
 *  十进制转十六进制
 *
 *  @param tmpid 十进制数
 *
 *  @return 返回十六进制字符串
 */
+ (NSString *)ToHex:(int)tmpid;
@end
