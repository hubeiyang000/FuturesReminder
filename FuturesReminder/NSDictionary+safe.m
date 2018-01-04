//
//  NSDictionary+safe.m
//  OneStore
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSDictionary+safe.h"

@implementation NSDictionary (safe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key
{
    if (object==nil || key==nil) {
        return [self dictionary];
    } else {
        return [self dictionaryWithObject:object forKey:key];
    }
}

- (id)objectForCaseInsensitiveKey:(NSString *)aKey
{
    if (!aKey) {
        return nil;
    }
    
    __block id returnObj = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *tempKey = key;
        if ([tempKey compare:aKey options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            returnObj = obj;
            *stop = YES;
        }
    }];
    
    return returnObj;
}
- (void)safeValue:(id)value forKey:(id)key{
    if (value==nil || key==nil) {
        
    } else {
        [self setValue:value forKey:key];
    }
}

@end
