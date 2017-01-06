//
//  JMSGViewUtil.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NIB(x)              (x *)[JMSGViewUtil nib:#x]
#define NIB_OWN(x, y)       (x *)[JMSGViewUtil nib:#x owner:y]
#define REG_NIB(x, y)       [JMSGViewUtil table:x registerNib:#y]
#define CELL(x, y)          (y *)[JMSGViewUtil table:x nib:#y]

@interface JMSGViewUtil : NSObject

+ (UIImage *)colorImage:(UIColor *)c frame:(CGRect)frame;

+ (UIView *)nib:(char *)nib;
+ (UIView *)nib:(char *)nib owner:(id)owner;

+ (UITableViewCell *)table:(UITableView *)table nib:(char *)nib;
+ (void)table:(UITableView *)table registerNib:(char *)nib;

@end
