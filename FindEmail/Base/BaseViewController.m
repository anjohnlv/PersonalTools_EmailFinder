//
//  BaseViewController.m
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self listening];
}

-(void)makeUI {

}

-(void)listening {

}

-(void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
