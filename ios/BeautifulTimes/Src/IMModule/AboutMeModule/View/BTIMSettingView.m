//
//  BTIMSettingView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMSettingView.h"

#define marginLeft 10

@interface  BTIMSettingView ()

@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *detailTitle;
@property (nonatomic,weak) UIButton *arrow;

@end

@implementation BTIMSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupChilView];
    }
    return self;
}

-(void)setupChilView
{
    //1.添加用户名
    UILabel *title = [[UILabel alloc]init];
    title.font = BT_FONTSIZE(17);
    title.textColor = [UIColor blackColor];
    [self addSubview:title];
    self.title = title;
    //2.添加详细标题
    UILabel *detailTitle = [[UILabel alloc]init];
    detailTitle.font = BT_FONTSIZE(15);
    detailTitle.textColor = [UIColor lightGrayColor];
    [self addSubview:detailTitle];
    detailTitle.hidden = YES;
    self.detailTitle = detailTitle;
    
    //3.添加箭头
    UIButton *arrow = [[UIButton alloc]init];
    CGFloat arrowW = 20;
    CGFloat arrowH = arrowW;
    CGFloat arrowY = (self.height-arrowH)*0.5;
    CGFloat arrowX = BT_SCREEN_WIDTH-arrowW-marginLeft;
    arrow.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    arrow.userInteractionEnabled= NO;
    [arrow setImage:BT_LOADIMAGE(@"pay_arrowright") forState:UIControlStateNormal];
    [self addSubview:arrow];
    self.arrow = arrow;
}

-(void)setSettingModel:(BTIMSettingModel *)settingModel
{
    _settingModel = settingModel;
    //1.计算title的frame
    CGSize titleS = [settingModel.title sizeWithAttributes:@{NSFontAttributeName:BT_FONTSIZE(17)}];
    CGFloat titleX;
    if(settingModel.isLoginOut){
        titleX = (BT_SCREEN_WIDTH-titleS.width)*0.5;
        self.arrow.hidden = YES;
    }else{
        titleX = marginLeft;
    }
    
    CGFloat titleY = (self.height - titleS.height) * 0.5;
    self.title.frame = CGRectMake(titleX, titleY, titleS.width, titleS.height);
    self.title.text = settingModel.title;
    //2.计算detailTitle
    if(settingModel.detailTitle.length > 0){
        self.detailTitle.hidden = NO;
        CGSize detailS = [settingModel.detailTitle sizeWithAttributes:@{NSFontAttributeName:BT_FONTSIZE(15)}];
        CGFloat detailW = detailS.width;
        CGFloat detailH = detailS.height;
        CGFloat detailY = (self.height - detailH) * 0.5;
        CGFloat detailX = BT_SCREEN_WIDTH - detailW - self.arrow.width - marginLeft;
        self.detailTitle.frame = CGRectMake(detailX, detailY, detailW, detailH);
        self.detailTitle.text = settingModel.detailTitle;
    }
}

@end
