//
//  InputViewController.m
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "InputViewController.h"
#import "InputView.h"

@interface InputViewController ()

@property(nonatomic, strong)InputView *inputView;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

-(void)makeUI {
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
}

-(void)listening {
    [self.inputView.cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.confirmButton addTarget:self action:@selector(inputURLs) forControlEvents:UIControlEventTouchUpInside];
}

-(void)inputURLs {
    NSString *urls = [self.inputView.textView text];
    if (self.inputBlock) {
        self.inputBlock(urls);
    }
    [self back];
}

-(void)back {
    self.inputBlock = nil;
    [super back];
}

-(void)setDefaultURL:(NSString *)defaultURL {
    [self.inputView.textView setText:defaultURL];
}

-(NSString *)defaultURL {
    NSAssert(NO, @"write only");
    return nil;
}

-(InputView *)inputView {
    if (!_inputView) {
        _inputView = [InputView new];
    }
    return _inputView;
}
@end
