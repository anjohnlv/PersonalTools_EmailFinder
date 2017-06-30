//
//  InputView.m
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "InputView.h"

@implementation InputView

const CGFloat kButtonSize = 30.f;

-(void)makeUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    _textView = [LimitedTextView new];
    [_textView setPlaceholder:@"输入需要查询Email的URL，多个URL以“,”隔开"];
    [_textView setBackgroundColor:[UIColor whiteColor]];
//    [_textView becomeFirstResponder];
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self).offset(kSpacing);
        make.left.equalTo(self).offset(kSpacing);
        make.right.equalTo(self).offset(-kSpacing);
        make.bottom.equalTo(self).offset(-2*kSpacing-kButtonSize);
    }];
    _confirmButton = [self addButtonWithTitle:@"✓"];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-kSpacing);
        make.bottom.equalTo(self).offset(-kSpacing);
        make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
    }];
    _cancelButton = [self addButtonWithTitle:@"✕"];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(kSpacing);
        make.bottom.equalTo(self).offset(-kSpacing);
        make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
    }];
}

-(UIButton *)addButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton new];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = kButtonSize/2;
    [button setBackgroundColor:WKT_ORANGE_COLOR];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}
@end
