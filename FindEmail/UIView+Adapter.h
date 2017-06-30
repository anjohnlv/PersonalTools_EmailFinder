//
//  UIView+Adapter.h
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

static const CGFloat kSpacing         = 12.f;
static const CGFloat kStatusBarHeight = 20.f;
static const CGFloat kFontSizeSmall   = 10.f;
static const CGFloat kFontSizeMedium  = 14.f;
static const CGFloat kFontSizeLarge   = 30.f;
@interface UIView (Adapter)

/**
 设置圆角

 @param rounded 是否圆角 radius 圆角幅度
 */
-(void)rounded:(BOOL)rounded;
-(void)rounded:(BOOL)rounded radius:(CGFloat)radius;
/**
 添加边框

 @param color 边框颜色
 */
-(void)addBorderWithColor:(UIColor *)color;

/**
 添加阴影

 @param color 阴影颜色
 */
-(void)addShadowWithColor:(UIColor *)color;

@end
