//
//  UIView+Adapter.m
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import "UIView+Adapter.h"

static const CGFloat kDefaultRadius        = 4.f;
static const CGFloat kDefaultBorderWidth   = .5f;
static const CGFloat kDefaultShadowOpacity = .9f;
static const CGFloat kDefaultShadowSize    = 4.f;

@implementation UIView (Adapter)

-(void)rounded:(BOOL)rounded {
    [self rounded:rounded radius:kDefaultRadius];
}

-(void)rounded:(BOOL)rounded radius:(CGFloat)radius{
    self.layer.masksToBounds = rounded;
    self.layer.cornerRadius = radius;
}

-(void)addBorderWithColor:(UIColor *)color {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = kDefaultBorderWidth;
}

-(void)addShadowWithColor:(UIColor *)color {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = CGSizeMake(kDefaultShadowSize,kDefaultShadowSize);
    self.layer.shadowOpacity = kDefaultShadowOpacity;
    self.layer.shadowRadius = kDefaultRadius;
}
@end
