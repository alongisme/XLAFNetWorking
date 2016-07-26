//
//  NSString+Category.m
//  AFNWorking3_0Demo
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


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

/**
 *  字符串反转函数
 *
 *  @param String 传入的字符串
 *
 *  @return 逆序后的字符串
 */
+ (NSString *)ReverserWithString:(NSString *)String {
    
    NSMutableString *str = [NSMutableString string];
    
    for (unsigned long i=(String.length); i>0; i--) {
        
        [str appendFormat:@"%c",[String characterAtIndex:i-1]];
        
    }
    
    return str;
}

/**
 *  判断是不是手机号
 *
 *  @param String  要判断的字符串
 *
 *  @return 返回yes或no
 */
+ (BOOL)isPhoneNumberWithString:(NSString *)String {
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:String];
}

/**
 *  MD5加密
 *
 *  @param String 要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)md5WithString:(NSString *)String {
    const char *cStr = [String UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

/**
 *  base64加密
 *
 *  @param text 要加密的字符串
 *
 *  @return 返回加密的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text {
    if (text && ![text isEqualToString:@""]) {
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        return [self base64EncodedStringFrom:data];
    }
    else {
        return @"";
    }
}

/**
 *  base64解密
 *
 *  @param base64 密文
 *
 *  @return 返回解密后的字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:@""]) {
        NSData *data = [self dataWithBase64EncodedString:base64];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return @"";
    }
}

/**
 *  base64解密
 *
 *  @param string string
 *
 *  @return 返回data
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
//        [NSException raise:NSInvalidArgumentException format:NULL];
        return [NSData data];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/**
 *  文本数据转base64
 *
 *  @param data data
 *
 *  @return 返回字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

/**
 *  十进制转十六进制
 *
 *  @param tmpid 十进制数
 *
 *  @return 返回十六进制字符串
 */
+ (NSString *)ToHex:(int)tmpid {
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}
@end
