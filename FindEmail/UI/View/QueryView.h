//
//  QueryView.h
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "BaseView.h"

@interface QueryView : BaseView

@property(nonatomic, strong)UIButton *queryButton,*exportButton;
@property(nonatomic, strong)UISegmentedControl *segmentedControl;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIProgressView *progressView;
@property(nonatomic, strong)UILabel *statusLabel;

@end
