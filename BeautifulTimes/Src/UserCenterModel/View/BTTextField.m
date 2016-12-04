//
//  BTTextField.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTTextField.h"

@interface BTTextField ()
@property (nonatomic,weak) UIImageView *img;

@end

@implementation BTTextField

-(instancetype)init {
    self=[super init];
    if(self){
        self.font = [UIFont systemFontOfSize:13];
//        self.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_content"];
    }
    return self;
}

-(void)setContentPlaceholder:(NSString *)contentPlaceholder
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName]=[UIColor grayColor];
    self.attributedPlaceholder=[[NSAttributedString alloc]initWithString:contentPlaceholder attributes:dict];
    
}
-(void)setImage:(NSString *)image {
    
    [[BTThemeManager getInstance] BTThemeImage:image completionHandler:^(UIImage *image) {
        
        UIImageView *img=[[UIImageView alloc]init];
        img.frame=CGRectMake(0, 10, 30, 30);
        [img setImage:image];
        self.leftViewMode=UITextFieldViewModeAlways; //总是显示
        self.leftView=img;
        self.img=img;
    } ];
    
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 10, 30, 30);
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.img.frame=CGRectMake(0, 0, 30, 30);
}

@end
