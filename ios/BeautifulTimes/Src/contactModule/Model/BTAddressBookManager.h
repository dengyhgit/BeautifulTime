//
//  BTAddressBookManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/11.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
@class BTAddressBook;

@protocol BTAddressBookManagerDelegate

//监听到通讯录发生改变后发生的回调
- (void) addressBookUpdatedCallBack;

@end

@interface BTAddressBookManager : NSObject

@property (nonatomic) ABAddressBookRef addressBooks;
@property (nonatomic, weak) id <BTAddressBookManagerDelegate> delegate;
@property (nonatomic, assign) BOOL shouldUpdateData; //是否需要更新到最新的通讯录

+ (BTAddressBookManager *) shareInstance;
//获取通讯录列表
+ (NSMutableArray *)getAddressBookData;
+(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchText;

//注册和注销接受通讯录变化通知
- (void)registerCallback ;
- (void)unregisterCallback;

/*
 * 使用语音通过人名来拨打电话
 * @param  人名
 * @return succ or not
 */
- (BOOL) searchContactByName:(NSString *) name;
/*
 * 通过电话号码搜索相应的联系人
 * @param 电话号码
 * @return 联系人
 */
- (BTAddressBook *) searchContactByPhone:(NSString *) phone;

@end
