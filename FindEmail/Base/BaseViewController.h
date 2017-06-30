//
//  BaseViewController.h
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewModel.h"
#import "BaseModel.h"

@interface BaseViewController : UIViewController

/**
 创建View
 */
-(void)makeUI;
/**
 监听View事件
 */
-(void)listening;

/**
 关闭视图
 */
-(void)back;
@end
