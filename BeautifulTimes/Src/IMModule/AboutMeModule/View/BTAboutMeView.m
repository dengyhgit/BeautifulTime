//
//  BTAboutMeView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAboutMeView.h"

#define headWidth 30
#define headHeight headWidth
#define marginLeft 10

@interface BTAboutMeView ()

@property (nonatomic,weak) UIImageView *head;
@property (nonatomic,weak) UILabel *name;
@property (nonatomic,weak) UILabel *detailTitle;
@property (nonatomic,weak) UIButton *arrow;

@end

@implementation BTAboutMeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self addAboutMeView];
    }
    return self;
}

-(void)addAboutMeView
{
    //1.添加头像
    UIImageView *head=[[UIImageView alloc]init];
    CGFloat headY=7;
    head.frame=CGRectMake(marginLeft, headY, headWidth, headHeight);
    [self addSubview:head];
    self.head=head;
    //2.添加用户名
    UILabel *name=[[UILabel alloc]init];
    name.font=BT_FONTSIZE(17);
    CGFloat nameX=CGRectGetMaxX(head.frame)+marginLeft*2;
    name.textColor=[UIColor blackColor];
    name.frame=CGRectMake(nameX, 7, 200, headHeight);
    [self addSubview:name];
    self.name=name;
    //3.添加详细标题
    UILabel *detailTitle=[[UILabel alloc]init];
    detailTitle.font=BT_FONTSIZE(15);
    detailTitle.textColor=[UIColor lightGrayColor];
    [self addSubview:detailTitle];
    detailTitle.hidden=YES;
    self.detailTitle=detailTitle;
    
    //4.添加箭头
    UIButton *arrow=[[UIButton alloc]init];
    
    CGFloat arrowW = 20;
    CGFloat arrowH = arrowW;
    CGFloat arrowY = (self.height - arrowH) * 0.5;
    CGFloat arrowX = BT_SCREEN_WIDTH - arrowW - marginLeft;
    arrow.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    arrow.userInteractionEnabled = NO;
    [arrow setImage:BT_LOADIMAGE(@"pay_arrowright") forState:UIControlStateNormal];
    [self addSubview:arrow];
    self.arrow = arrow;
}

//设置模型
-(void)setItem:(BTAboutMeCellModel *)item
{
    _item = item;
    if(item.image){
        self.head.layer.cornerRadius = 5;
        self.head.layer.borderWidth = 0.5;
        self.head.layer.borderColor = [UIColor grayColor].CGColor;
        self.head.image = [UIImage imageWithData:item.image];
    }else{
        self.head.image = BT_LOADIMAGE(item.icon);
    }
    WS(weakSelf);
    if (item.user) {
        [item.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (data) {
                weakSelf.head.image = [[UIImage alloc] initWithData:data];
            } else {
                weakSelf.head.image = BT_LOADIMAGE(@"com_ic_defaultIcon");
            }
        }];
    }
    
    self.name.text = item.title;
    if(item.detailTitle){
        self.detailTitle.hidden = NO;
        CGSize detailS = [item.detailTitle sizeWithAttributes:@{NSFontAttributeName:BT_FONTSIZE(15)}];
        CGFloat detailW = detailS.width;
        CGFloat detailH = detailS.height;
        CGFloat detailY = (self.height - detailH) * 0.5;
        CGFloat detailX = BT_SCREEN_WIDTH - detailW - self.arrow.width - marginLeft;
        self.detailTitle.frame = CGRectMake(detailX, detailY, detailW, detailH);
        self.detailTitle.text = item.detailTitle;
    }
}

@end
