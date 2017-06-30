//
//  MBProgressHUD+Extension.h
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)

/**
 hud默认屏幕居中显示 可由+hide关闭。

 @return MBProgressHUD
 */
+ (instancetype)show;
/**
 隐藏由+show实例化的hud。
 */
+ (void)hide;


/**
 ToastHud 默认自动隐藏。

 @param toast nil显示“Error”
 */
+ (void)showToast:(NSString *)toast;
/**
 ToastHud

 @param toast Toast nil显示“Error”
 @param duration 小于等于0则不会自动隐藏，可由+hide关闭。
 */
+ (void)showToast:(NSString *)toast duration:(CGFloat)duration;

@end
