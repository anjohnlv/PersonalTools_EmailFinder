//
//  QueryView.m
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "QueryView.h"



@implementation QueryView

-(void)makeUI {
    _queryButton = [UIButton new];
    [_queryButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [_queryButton setTintColor:WKT_ORANGE_COLOR];
    [self addSubview:_queryButton];
    [_queryButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    _statusLabel = [UILabel new];
    [_statusLabel setText:@"请输入网址"];
    [_statusLabel setFont:[UIFont systemFontOfSize:kFontSizeSmall]];
    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
    [_statusLabel setTextColor:WKT_GRAY_COLOR];
    [_statusLabel setFont:[UIFont systemFontOfSize:kFontSizeMedium]];
    [self addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_queryButton.mas_bottom).offset(kSpacing/2);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(kSpacing);
        make.height.mas_equalTo(kFontSizeMedium);
    }];
    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    [_progressView setProgressTintColor:WKT_GRAY_COLOR];
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_statusLabel.mas_bottom).offset(1);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(kSpacing);
    }];
    _tableView = [UITableView new];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(kSpacing);
        make.top.equalTo(_progressView.mas_bottom).offset(2);
        make.bottom.equalTo(self).offset(-kSpacing);
    }];
    
//    _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"邮箱",@"电话"]];
//    [_segmentedControl setSelectedSegmentIndex:0];
//    [_segmentedControl setTintColor:WKT_ORANGE_COLOR];
//    [self addSubview:_segmentedControl];
//    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(_queryButton);
//        make.left.equalTo(self).offset(kSpacing);
//    }];
    _exportButton = [UIButton new];
    [_exportButton setEnabled:NO];
    [_exportButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_exportButton setTintColor:WKT_ORANGE_COLOR];
    [self addSubview:_exportButton];
    [_exportButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_queryButton);
        make.right.equalTo(self).offset(-kSpacing);
        make.size.equalTo(_queryButton);
    }];
}

@end
