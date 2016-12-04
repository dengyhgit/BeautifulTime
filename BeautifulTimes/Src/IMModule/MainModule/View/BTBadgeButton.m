//
//  BTBadgeButton.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/23.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTBadgeButton.h"

@implementation BTBadgeButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.hidden=YES;
        self.titleLabel.font=BT_FONTSIZE(11);
        [self setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"tabbar_badge")] forState:UIControlStateNormal];
        self.userInteractionEnabled=NO;
    }
    return self;
}


-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue=[badgeValue copy];  //copy值
    
    if(badgeValue && ![badgeValue isEqualToString:@"0"] && ![badgeValue isEqualToString:@""]){
        self.hidden=NO;
        //设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        //如果大于1个数字
        if(badgeValue.length>1){
            
            CGSize btnSize=[badgeValue sizeWithAttributes:@{NSFontAttributeName:BT_FONTSIZE(11)}];
            self.width=btnSize.width+20; //宽度+10
            self.height=self.currentBackgroundImage.size.height;
        }else{
            self.width=self.currentBackgroundImage.size.width;
            self.height=self.currentBackgroundImage.size.height;
        }
        
    }else{
        self.hidden=YES;
    }
}
@end
