//
//  BTAddressBookManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/11.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddressBookManager.h"
#import "BTAddressBook.h"
#import "AppDelegate.h"

#define KPHONELABELDICDEFINE		@"KPhoneLabelDicDefine"
#define KPHONENUMBERDICDEFINE       @"KPhoneNumberDicDefine"
#define KPHONENAMEDICDEFINE         @"KPhoneNameDicDefine"

static BTAddressBookManager * addressBookManager = nil;

@interface BTAddressBookManager () {
    BOOL _hasRegister;
    BOOL _isFirstTimeRequestAccess;
    
}

@property (nonatomic, strong) NSMutableArray * addressBookArray;

@end

@implementation BTAddressBookManager

+ (BTAddressBookManager *) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressBookManager = [[BTAddressBookManager alloc]init];
    });
    return addressBookManager;
}

- (BTAddressBookManager *) init {
    if (self = [super init]) {
        _hasRegister = NO;
        _isFirstTimeRequestAccess = YES;
        _shouldUpdateData = YES;
    }
    return self;
}

- (void) dealloc {
    [[BTAddressBookManager shareInstance] unregisterCallback];//or will more than once
}

#pragma mark -
#pragma mark - 通讯录增加人名或删除人名的callback
void addressCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    
    BTAddressBookManager * manager = (__bridge BTAddressBookManager *) context;
    
    manager.shouldUpdateData = YES;
    if (manager.delegate && manager.delegate ) {
        [manager.delegate addressBookUpdatedCallBack];
    }
    
}
- (void)registerCallback {
    
    if (!_hasRegister && self.addressBooks) {
        ABAddressBookRegisterExternalChangeCallback(_addressBooks, addressCallback, (__bridge void *)(self));
        _hasRegister = YES ;
    }
}

- (void)unregisterCallback {
    if (_hasRegister && self.addressBooks) {
        ABAddressBookUnregisterExternalChangeCallback(_addressBooks, addressCallback, (__bridge void *)(self));
        _hasRegister = NO;
    }
}

#pragma mark -
#pragma mark 获取通讯录
- (ABAddressBookRef ) addressBooks {
    _addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    //get granted
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(_addressBooks, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
            if (granted) {
                [self performSelectorOnMainThread:@selector(registerCallback) withObject:nil waitUntilDone:NO];
            }
            else {
                //不能获取通讯录
            }
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        _isFirstTimeRequestAccess = NO;
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        
        //规避iOS9 xCode7 关闭通讯录隐私权限后，启动app会立即crash的问题
        UIViewController * vc = [[AppDelegate getInstance]currentTopVc ];
        if ([vc isKindOfClass:NSClassFromString(@"BTAddressBookViewController")]) {
//            [[BAlertViewManager getInstance] showAlertViewWithTag:0 title:nil message:@"请在设备的设置-隐私-通讯录中允许访问通讯录。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了",nil];
//            
        }
        
        
        return nil;
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self performSelectorOnMainThread:@selector(registerCallback) withObject:nil waitUntilDone:NO];
    }
    return _addressBooks;
}

#pragma mark -
#pragma mark 类方法，获取通讯录
+ (NSMutableArray *) getAddressBookData {
    NSMutableArray *   addressBookArray = [[NSMutableArray alloc]init];
    
    BTAddressBookManager * manager = [BTAddressBookManager shareInstance];
    ABAddressBookRef addressBooks = [manager addressBooks];
    if (addressBooks) {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        for (int i = 0; i < nPeople; i++) {
            BTAddressBook *addressBook = [[BTAddressBook alloc] init];
            
            //get a person's info from allPeople by index
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString * nameString = (__bridge NSString *)abName;
            NSString * lastNameString = (__bridge NSString * )abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            }
            else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            
            if (!nameString) {
                nameString = @"未知";
            }
            addressBook.photo = nil;
            addressBook.name = nameString;
            addressBook.recordID = (int)ABRecordGetRecordID(person);
            addressBook.record = person;
            if ([BTAddressBookManager getPhoneNumberAndPhoneLabelArray:addressBook]) {
                [addressBookArray addObject:addressBook];
            }
            
            if (abName) {
                CFRelease(abName);
            }
            if (abLastName) {
                CFRelease(abLastName);
            }
            if (abFullName) {
                CFRelease(abFullName);
            }
        }
        CFRelease(allPeople);
    }
    
    return addressBookArray;
}
//得到联系人的号码组与Label组
+ (BOOL) getPhoneNumberAndPhoneLabelArray:(BTAddressBook *)contact {
    NSMutableDictionary *phoneDic;
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(contact.record, kABPersonPhoneProperty);
    int i;
    if (ABMultiValueGetCount(phoneMulti) == 0) {
        //没存电话则不放入通讯录列表
        CFRelease(phoneMulti);
        return NO;
    }
    else {
        for (i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
            NSString *label =  (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
            //phone 要去空格 否则有空格的电话打不出
            if (phone) {
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            phoneDic = [[NSDictionary dictionaryWithObjectsAndKeys:contact.name, KPHONENAMEDICDEFINE, phone, KPHONENUMBERDICDEFINE, label,KPHONELABELDICDEFINE,nil] mutableCopy];
            [phoneArray addObject:phoneDic];
            if (i == 0) {
                contact.tel = phone;
            }
        }
        contact.telGroup = phoneArray;
        CFRelease(phoneMulti);
        return YES;
    }
}


//两个字符串比较是否相等
+(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT {
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

#pragma mark -
#pragma mark 通过电话号码搜索相应的联系人
- (BTAddressBook *) searchContactByPhone:(NSString *) phone {
    if (!phone && [phone isEqualToString:@""]) {
//        NSLog(@"电话为空");
        return nil;
    }
    if ([self.addressBookArray count] == 0 || self.shouldUpdateData) {
        self.addressBookArray = [BTAddressBookManager getAddressBookData];
        if ([self.addressBookArray count] == 0) {
//            NSLog(@"电话本为空");
            return nil;
        }
        else {
            if(self.shouldUpdateData)
                self.shouldUpdateData = NO;
        }
    }
    for (BTAddressBook * addressBook in self.addressBookArray) {
        NSArray * telGroup = addressBook.telGroup;
        for (NSDictionary * phoneDic in telGroup) {
            NSString * tmpPhone = [phoneDic objectForKey:KPHONENUMBERDICDEFINE];
            BOOL result = NO;
            if([tmpPhone isEqualToString:phone] )
                result = YES;
            
            if (result) {
//                NSLog(@"找到联系人");
                return addressBook;
            }
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark 通过人名来拨打电话
-(BOOL) searchContactByName:(NSString *)name {
    if (!name || [name isEqualToString:@""]) {
//        NSLog(@"输入的名字为空");
        return NO;
    }
    if ([self.addressBookArray count] == 0 || self.shouldUpdateData) {
        self.addressBookArray = [BTAddressBookManager getAddressBookData];
        if ([self.addressBookArray count] == 0) {
//            NSLog(@"搜索失败，电话本为空");
            return NO;
        }
        else {
            if(self.shouldUpdateData)
                self.shouldUpdateData = NO;
        }
    }
    NSString * searchNamePinyin = [self stringToPinyin:name];
    
    NSMutableArray * resultArr = [[NSMutableArray alloc]init];
    
    for (BTAddressBook * addressBook in self.addressBookArray) {
        if (addressBook.pinyin == nil) {
            addressBook.pinyin = [self stringToPinyin:addressBook.name];
        }
        BOOL result = NO;
        BOOL fullMatch = NO; //与要搜索的姓名完全匹配
        if([addressBook.pinyin rangeOfString:searchNamePinyin].location != NSNotFound) {
            if(addressBook.pinyin.length == searchNamePinyin.length) {
                fullMatch = YES;
            }
            result = YES;
        }
        if (result) {
            [resultArr addObject:addressBook];
        }
        if (fullMatch) {
            //完全匹配的联系人放数组的第一位
            [resultArr insertObject:addressBook atIndex:0];
        }
    }
    if ([resultArr count]) {
//        NSLog(@"找到联系人");
//        [BTAudioStatusManager sharedInstance].callStatus = prepareCall;
//        [[BTCallManager shareInstance]callSomeoneByPhoneViaVoice:[resultArr firstObject]];
        return YES;
    }
    
    return NO;
}

- (NSString *)stringToPinyin:(NSString *)string {
    CFMutableStringRef mutStr = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)(string));
    CFStringTransform(mutStr, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(mutStr, NULL, kCFStringTransformStripDiacritics, NO);
    NSString * str = (__bridge NSString *)(mutStr);
    CFRelease(mutStr);
    return str;
}

- (NSMutableArray *) addressBookArray {
    if (!_addressBookArray) {
        _addressBookArray = [[NSMutableArray alloc]init];
    }
    return _addressBookArray;
}

@end
