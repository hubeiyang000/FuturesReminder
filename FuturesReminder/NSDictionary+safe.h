//
//  NSDictionary+safe.h
//  OneStore
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

/**
 *  忽略key大小写查询字典
 *
 *  @param aKey
 *
 *  @return
 */
- (id)objectForCaseInsensitiveKey:(NSString *)aKey;

- (void)safeValue:(id)value forKey:(id)key;

@end
