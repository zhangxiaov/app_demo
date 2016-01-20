//
//  AppConfig.h
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#ifndef app_demo_AppConfig_h
#define app_demo_AppConfig_h

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define NORMAL_PADDING SCREEN_WIDTH*0.04

#define UIColorFromHex(hexvalue) [UIColor colorWithRed:((float)((hexvalue & 0xFF0000) >> 16))/255.0 green:((float)((hexvalue & 0xFF00) >> 8))/255.0 blue:((float)(hexvalue & 0xFF))/255.0 alpha:1.0]

#define FONT_SIZE_CONTENT 15.0

#define CONTENT_HEIGHT (SCREEN_HEIGHT - 40)
#define CONTENT_WIDTH (SCREEN_WIDTH - 20)

#define NFONT9 9
#define NFONT10 10
#define NFONT11 11
#define NFONT12 12
#define NFONT13 13
#define NFONT14 14
#define NFONT15 15
#define NFONT16 16
#define NFONT17 17
#define NFONT18 18
#define NFONT19 19
#define NFONT20 20

#define	MAX(a,b) (((a)>(b))?(a):(b))

typedef NS_ENUM(NSInteger, ZMessageType) {
    ZMessageTypeText = 1,
    ZMessageTypeImage,
    ZMessageTypeVoice,
};

#define statusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

#endif
