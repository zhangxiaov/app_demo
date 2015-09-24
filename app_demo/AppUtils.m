//
//  AppUtils.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils
+ (NSData *)data:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
@end
