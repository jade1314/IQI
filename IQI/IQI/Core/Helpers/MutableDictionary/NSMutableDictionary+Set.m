//
//  NSMutableDictionary+Set.m
//  PanGu
//
//  Created by 陈伟平 on 16/7/12.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "NSMutableDictionary+Set.h"

@implementation NSMutableDictionary (Set)

-(void)setNObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject == nil || anObject == NULL || [anObject isKindOfClass:[NSNull class]]) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

-(void)setNValue:(id)value forKey:(NSString *)key{
    if (value == nil || value == NULL || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    [self setValue:value forKey:key];
}
@end
