//
//  NSMutableDictionary+Category.m
//  AFNWorking3_0Demo
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 3ti. All rights reserved.
//

#import "NSMutableDictionary+Category.h"

@implementation NSMutableDictionary (NSMutableDictionary_Category)
/**
 *  添加非空字符串
 *
 *  @param date 字符串
 *  @param key  关键字
 */
- (void)addUnEmptyString:(NSString *)stringObject forKey:(NSString *)key{
    
    if ([NSString checkIsStringEmpty:stringObject]) {
        [self setObject:@"" forKey:key];
    }else{
        [self setObject:stringObject forKey:key];
    }
    
}
@end
