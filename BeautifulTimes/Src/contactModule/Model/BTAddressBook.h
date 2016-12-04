//
//  BTAddressBook.h
//  BeautifulTimes
//
//  Created by deng on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface BTAddressBook : NSObject

@property  NSInteger recordID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSMutableArray * telGroup;
@property (nonatomic) ABRecordRef record ;
@property (nonatomic, strong) UIImage * photo;
@property (nonatomic, strong) NSString * pinyin;

@end
