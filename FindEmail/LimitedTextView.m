//
//  LimitedTextView.m
//  vcDemo
//
//  Created by wdwk on 2017/3/23.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import "LimitedTextView.h"

@interface LimitedTextView()<UITextViewDelegate>

@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)UILabel *limitLabel,*placeholderLabel;;

@end

@implementation LimitedTextView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addBorderWithColor:WKT_GRAY_COLOR];
        [self rounded:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        _textView = [UITextView new];
        [_textView setDelegate:self];
        [_textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_textView setTextAlignment:NSTextAlignmentLeft];
        [_textView setFont:[UIFont systemFontOfSize:kFontSizeMedium]];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-2*kSpacing);
        }];
        _limitLabel = [UILabel new];
        [_limitLabel setHidden:YES];
        [_limitLabel setFont:[UIFont systemFontOfSize:kFontSizeSmall]];
        [_limitLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_limitLabel];
        [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.and.bottom.equalTo(self).offset(-kSpacing);
        }];
        _placeholderLabel = [UILabel new];
        [_placeholderLabel setFont:[UIFont systemFontOfSize:kFontSizeMedium]];
        [_placeholderLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_textView);
            make.left.equalTo(_textView).offset(5);
        }];
    }
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder {
    [_placeholderLabel setText:placeholder];
    _placeholder = placeholder;
}

-(void)setText:(NSString *)text {
    if (!text || [text length] <= 0) {
        [_placeholderLabel setHidden:NO];
    }else{
        [_placeholderLabel setHidden:YES];
        [_textView setText:text];
        [self countLimit:text];
    }
}

-(NSString *)text {
    return [_textView text];
}

-(void)setLimitCount:(int)limitCount {
    if (limitCount > 0) {
        [_limitLabel setText:[NSString stringWithFormat:@"还可以输入%d个字", limitCount]];
        _limitCount = limitCount;
        [_limitLabel setHidden:NO];
    }else{
        _limitCount = 0;
        [_limitLabel setHidden:YES];
    }
}

-(void)countLimit:(NSString *)content {
    int count = 0;
    if (content) {
        count = (int)[content length];
    }
    [_limitLabel setText:[NSString stringWithFormat:@"还可以输入%d个字",_limitCount-count]];
    if (self.changedBlcok) {
        self.changedBlcok(content);
    }
}

-(BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

-(BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [_placeholderLabel setHidden:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    NSString *text = [textView text];
    if (!text || [text length]<=0) {
        [_placeholderLabel setHidden:NO];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    NSString *text = [textView text];
    [self countLimit:text];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (_limitCount == 0) {
        return YES;
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = _limitCount - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}


@end
