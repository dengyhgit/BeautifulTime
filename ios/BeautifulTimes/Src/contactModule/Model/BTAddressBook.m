//
//  BTAddressBook.m
//  BeautifulTimes
//
//  Created by deng on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddressBook.h"

@implementation BTAddressBook

- (NSString *) name {
    if (!_name) {
        _name = [[NSString alloc]init];
    }
    return _name;
}
- (NSString *) email {
    if (!_email) {
        _email = [[NSString alloc]init];
    }
    return _email;
}
- (NSString *)tel {
    if (!_tel) {
        _tel = [[NSString alloc]init];
    }
    return _tel;
}
- (NSMutableArray *) telGroup {
    if (!_telGroup) {
        _telGroup = [[NSMutableArray alloc]init];
    }
    return _telGroup;
}

@end
