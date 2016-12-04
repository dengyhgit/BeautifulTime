//
//  BTEditUserInfoView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTEditUserInfoView.h"

@implementation BTEditUserInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self addEditInput];
    }
    return self;
}

-(void)addEditInput
{
    BTTextField *input=[[BTTextField alloc]init];
    input.x=10;
    input.y=0;
    input.width=BT_SCREEN_WIDTH-20;
    input.height=self.height;
    
    [self addSubview:input];
    input.text=self.str;
    input.font=BT_FONTSIZE(17);
    self.textField=input;
}
-(void)setStr:(NSString *)str
{
    self.textField.text=str;
}
@end
