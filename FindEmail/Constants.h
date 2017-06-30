//
//  Constants.h
//  FlipCourse
//
//  Created by webseat2 on 13-10-28.
//  Copyright (c) 2013年 WebSeat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_RETINA ((([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) == YES) ? YES:NO)
#define IS_PHONE (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)?YES:NO)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WKT_WHITE_COLOR UIColorFromRGB(0xf1f1f1)
#define WKT_GRAY_COLOR UIColorFromRGB(0xd4d4d4)
#define WKT_ORANGE_COLOR UIColorFromRGB(0xff7f00)
#define WKT_RED_COLOR UIColorFromRGB(0xaa0000)
#define WKT_GREEN_COLOR UIColorFromRGB(0x3cb371)

@interface Constants : NSObject


@end
