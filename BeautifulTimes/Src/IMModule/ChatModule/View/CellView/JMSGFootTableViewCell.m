//
//  JMSGFootTableViewCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFootTableViewCell.h"

@implementation JMSGFootTableViewCell

- (void)awakeFromNib {
    _quitGroupBtn.layer.cornerRadius = 4;
    _quitGroupBtn.layer.masksToBounds = YES;
    _quitGroupBtn.backgroundColor = [UIColor redColor];
    [_quitGroupBtn setBackgroundImage:[JMSGViewUtil colorImage:[UIColor blackColor] frame:_quitGroupBtn.frame] forState:UIControlStateHighlighted];
    UIView *separatLine = [UIView new];
    [self addSubview:separatLine];
    [separatLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self);
    }];
    separatLine.backgroundColor = kSeparationLineColor;
    
    _baseLine = [UIView new];
    [self addSubview:_baseLine];
    [_baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self).with.offset(0.5);
    }];
    _baseLine.backgroundColor = kSeparationLineColor;
    _baseLine.hidden = YES;
    
    _NoDisturbView.hidden = YES;
    [_nodisturbSwitch setOn:NO animated:NO];

}

- (IBAction)didSelectNoDisturbAction:(UISwitch *)sender {
    
    if (_didSelectNoDisturbBlock) {
        _didSelectNoDisturbBlock(_nodisturbSwitch.isOn);
    }
}
- (void)layoutNoDisturbView {
    _footerTittle.hidden = YES;
    _userName.hidden = YES;
    _arrow.hidden = YES;
    _quitGroupBtn.hidden = YES;
    _baseLine.hidden = YES;
    _NoDisturbView.hidden = NO;
}

- (void)setDataWithGroupName:(NSString *)groupName {
    _footerTittle.hidden = NO;
    _userName.hidden = NO;
    _arrow.hidden = NO;
    _quitGroupBtn.hidden = YES;
    _baseLine.hidden = YES;
    _footerTittle.text = @"群聊名称";
    _userName.text = groupName;
    _NoDisturbView.hidden = YES;
}

- (void)layoutToClearChatRecord {
    _footerTittle.hidden = NO;
    _userName.hidden = NO;
    _arrow.hidden = NO;
    _quitGroupBtn.hidden = YES;
    _baseLine.hidden = NO;
    _footerTittle.text = @"清空聊天记录";
    _userName.text = @"";
    _NoDisturbView.hidden = YES;
}

- (void)layoutToQuitGroup {
    _footerTittle.hidden = YES;
    _userName.hidden = YES;
    _arrow.hidden = YES;
    _quitGroupBtn.hidden = NO;
    _baseLine.hidden = YES;
    _NoDisturbView.hidden = YES;
}

- (IBAction)clickToQuitGroup:(id)sender {// rename
    [_delegate quitGroup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor whiteColor];
}


@end
