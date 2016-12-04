//
//  BTEditUserInfoView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTextField.h"

@interface BTEditUserInfoView : UIView

@property (nonatomic,copy) NSString *str;
@property (nonatomic,weak) BTTextField *textField;

@end
