//
//  MBProgressHUD+Extension.m
//  ProjectFrameDemo
//
//  Created by wdwk on 2017/6/13.
//  Copyright © 2017年 eastedu. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

const CGFloat kToastDuration = 3.f;

+ (instancetype)keyWindowHUD{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[self alloc] initWithView:window];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [window addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (instancetype)show {
    [self hide];
    MBProgressHUD *hud = [self keyWindowHUD];
    return hud;
}

+ (void)showToast:(NSString *)toast {
    [self showToast:toast duration:kToastDuration];
}

+ (void)showToast:(NSString *)toast duration:(CGFloat)duration {
    [self hide];
    if (!toast) {
        toast = @"Error";
    }
    MBProgressHUD *hud = [self keyWindowHUD];
    hud.label.numberOfLines = 2;
    hud.label.text = toast;
    hud.mode = MBProgressHUDModeText;
    if (duration > 0) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(duration);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
    }
}

+ (void)hide {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [self HUDForView:window];
    if (hud != nil) {
        [hud hideAnimated:YES];
    }
}

@end
