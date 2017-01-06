//
//  BTObjectExtension.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    NSStringOperationTypeTrim,          // 去空
//    NSStringOperationTypeNone,          // 无需额外操作
//} NSStringOperationType;

// Extension of NSString
@interface NSString (BTExtension)

// 去除尾部space
- (NSString*)trim;

@end


// Extension of NSDictionary
@interface NSDictionary (BTExtension)

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue operation:(NSStringOperationType)type;

@end

