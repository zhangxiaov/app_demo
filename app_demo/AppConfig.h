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

#define FONT_SIZE_MAX 15.0

#endif
