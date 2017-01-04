//
//  JMSGMoreView.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGMoreView.h"

@implementation JMSGMoreView

- (IBAction)photoBtnClick:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
        [self.delegate photoClick];
    }
}
- (IBAction)cameraBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
        [self.delegate cameraClick];
    }
}

- (IBAction)fileBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(fileClick)]) {
        [self.delegate fileClick];
    }
}

- (IBAction)locationBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(locationClick)]) {
        [self.delegate locationClick];
    }
}

@end


@implementation JMSGMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _moreView = NIB(JMSGMoreView);
    _moreView.frame = CGRectMake(0, 0, 320, 227);
    [self addSubview:_moreView];
}

@end

