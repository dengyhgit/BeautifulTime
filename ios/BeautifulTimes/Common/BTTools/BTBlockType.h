//
//  BTBlockType.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#ifndef BeautifulTimes_BTBlockType_h
#define BeautifulTimes_BTBlockType_h

typedef void (^ViewBlock)(UIView *view);
typedef void (^ImageBlock)(UIImage *image);
typedef void (^ButtonBlock)(UIButton *btn);
typedef void (^VoidBlock)(void);
typedef void (^BOOLBlock)(BOOL bigBOOL);
typedef BOOL (^BOOLReturnBlock)(BOOL bigBool);
typedef void (^VoidBooLBlock)(BOOL bigBool);
typedef BOOL (^BOOLVoidBlock)(void);
typedef void (^ArrayResponseBlock)(NSArray *resultArray);
typedef void (^DictionaryResponseBlock)(NSDictionary *retDict);
typedef void (^StringResponseBlock)(NSString* responseString);
typedef void (^DataBlock)(NSData *data);
typedef void (^DoubleBlock)(double doubleValue);
typedef void (^errorBlock)(NSError *error);

#endif
