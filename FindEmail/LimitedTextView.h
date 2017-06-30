//
//  LimitedTextView.h
//  vcDemo
//
//  Created by wdwk on 2017/3/23.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import "BaseView.h"

@interface LimitedTextView : BaseView

typedef void (^TextChangedBlock) (NSString *text);

@property(nonatomic, copy)TextChangedBlock changedBlcok;
@property(nonatomic, strong)NSString *text,*placeholder;
/**
 *  文本框输入限制，小于等于零时表示不限制字数
 */
@property(nonatomic)int limitCount;

//-(BOOL)resignFirstResponder;
@end
