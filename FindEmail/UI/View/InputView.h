//
//  InputView.h
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "BaseView.h"
#import "LimitedTextView.h"

@interface InputView : BaseView

@property(nonatomic, strong)LimitedTextView *textView;
@property(nonatomic, strong)UIButton *confirmButton,*cancelButton;

@end
