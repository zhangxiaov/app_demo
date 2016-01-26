//
//  AppUtils.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppUtils.h"
#import "AppConfig.h"
#import <UIKit/UIKit.h>

@implementation AppUtils
+ (NSData *)data:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

+ (CGFloat)heightForText:(NSString *)text {
    
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary* attrbute = @{ NSFontAttributeName : [UIFont systemFontOfSize:14] };
    return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}
@end
