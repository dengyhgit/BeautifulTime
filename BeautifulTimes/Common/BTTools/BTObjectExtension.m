//
//  BTObjectExtension.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTObjectExtension.h"

@implementation NSString (BTExtension)

- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

@implementation NSDictionary (BTExtension)

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue operation:(NSStringOperationType)type {
    if (key != nil && [key length] > 0) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null]) {
            if ([ret isKindOfClass:[NSString class]]) {
                switch (type) {
                    case NSStringOperationTypeNone: {
                        return ret;
                    }
                    case NSStringOperationTypeTrim:
                    default: {
                        return [ret trim];
                    }
                }
            }
            else if ([ret isKindOfClass:[NSDecimalNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
            else if ([ret isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
        }
    }
    return defaultValue;
}

@end
