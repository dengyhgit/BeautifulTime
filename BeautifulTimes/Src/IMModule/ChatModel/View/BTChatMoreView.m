//
//  BTChatMoreView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/4/1.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatMoreView.h"

@implementation BTChatMoreView

- (void)drawRect:(CGRect)rect {
  
}

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
@end


@implementation JCHATMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  
  NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"BTChatMoreView"
                                                owner:self
                                            options:nil];
  _moreView = (BTChatMoreView *)nibs[0];
  
  _moreView.frame =CGRectMake(0, 0, BT_SCREEN_WIDTH, 227);
  
  [self addSubview:_moreView];
}

@end

