//
//  InputViewController.h
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^InputURLStringBlock) (NSString *text);

@interface InputViewController : BaseViewController

@property(nonatomic, strong)NSString *defaultURL;
@property(nonatomic)InputURLStringBlock inputBlock;

@end
