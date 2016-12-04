//
//  BTTabBarButton.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTabBarButton.h"
#import "BTBadgeButton.h"

#define tabbarButtonImageRatio 0.65

@interface BTTabBarButton ()

@property (nonatomic,weak) BTBadgeButton *badgeButton;

@end

@implementation BTTabBarButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = BT_FONTSIZE(11);
        
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        BTBadgeButton *badge = [[BTBadgeButton alloc] init];
        //按钮自动适应
        badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:badge];
        self.badgeButton = badge;
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width; //文字的宽度
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;  //图片的高度
    CGFloat titleH = contentRect.size.height-imageH;  //文字的高度=按钮的高度-图片的高度
    
    return CGRectMake(0, imageH, titleW, titleH);
}

#pragma mark 设置item
-(void)setItem:(UITabBarItem *)item
{
    _item=item;
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    
    //设置按钮的颜色
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    
    //添加提醒数字按钮
    self.badgeButton.badgeValue = item.badgeValue;
    self.badgeButton.y = -5;
    
    CGFloat badgeX = 0;
    
    if(BT_SCREEN_WIDTH > 375){     //6plus
        badgeX = self.width - self.badgeButton.width - 26;
    }
    else if(BT_SCREEN_WIDTH > 320){  //6
        badgeX = self.width - self.badgeButton.width - 21;
    }
    else{   //4-5s
        badgeX = self.width - self.badgeButton.width - 16;
    }
    self.badgeButton.x = badgeX;
}

#pragma mark 监听item值的改变
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    //添加提醒数字按钮
    self.badgeButton.badgeValue = self.item.badgeValue;
    self.badgeButton.y = -5;
    
    CGFloat badgeX = 0;
    if(BT_SCREEN_WIDTH > 375){
        badgeX = self.width - self.badgeButton.width - 26;
    }
    else if(BT_SCREEN_WIDTH > 320){  //iPhone 6
        badgeX = self.width - self.badgeButton.width - 21;
    }
    else{   //4-5s
        badgeX = self.width - self.badgeButton.width - 16;
    }
    self.badgeButton.x=badgeX;
}

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

@end
