//
//  KFObjectExtension.m
//  KoalaFramework
//
//  Created by Menglin CHEN on 10/26/12.
//  Copyright (c) 2012 CML. All rights reserved.
//

#import "KFObjectExtension.h"
#import "zlib.h"

#define kMemoryChunkSize 1024

@implementation NSString (KFExtension)

- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)decodeUnicode {
    
    NSString* str1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* str3 = [@"\"" stringByAppendingString:str2];
    NSString* str4 = [str3 stringByAppendingString:@"\""];
    NSString* str5 = [NSPropertyListSerialization propertyListWithData:[str4 dataUsingEncoding:NSUTF8StringEncoding] options:NSPropertyListImmutable format:NULL error:NULL];
    return [str5 stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

#pragma mark 把汉字转成把拼音
-(NSString *)stringToPinyin {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        
    }
    return ms;
}


@end



@implementation NSDictionary (KFExtension)

- (NSDictionary*)dictionaryValueForKey:(NSString*)key defaultValue:(NSDictionary*)defaultValue {
    if (key != nil && [key length] > 0) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null] && [ret isKindOfClass:[NSDictionary class]]) {
            return ret;
        }
    }
    return defaultValue;
}

- (NSArray*)arrayValueForKey:(NSString*)key defaultValue:(NSArray*)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null] && [ret isKindOfClass:[NSArray class]]) {
			return ret;
		}
	}
	return defaultValue;
}

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue operation:(NSStringOperationType)type {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null]) {
			if ([ret isKindOfClass:[NSString class]]) {
				switch (type) {
					case NSStringOperationTypeDecodeUnicode: {
						return [[ret trim] decodeUnicode];
					}
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

- (int)intValueForKey:(NSString*)key defaultValue:(int)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
			return [ret intValue];
		}
	}
	return defaultValue;
}

- (uint64_t)longLongValueForKey:(NSString*)key defaultValue:(uint64_t)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
			return [ret longLongValue];
		}
	}
	return defaultValue;
}

- (double)doubleValueForKey:(NSString*)key defaultValue:(double)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
			return [ret doubleValue];
		}
	}
	return defaultValue;
}

- (float)floatValueForKey:(NSString*)key defaultValue:(float)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
			return [ret floatValue];
		}
	}
	return defaultValue;
}

- (BOOL)boolValueForKey:(NSString*)key defaultValue:(BOOL)defaultValue {
    if (key != nil && [key length] > 0) {
		id ret = [self objectForKey:key];
		if (ret != nil && ret != [NSNull null]) {
			return [ret boolValue];
		}
	}
	return defaultValue;
}

@end

