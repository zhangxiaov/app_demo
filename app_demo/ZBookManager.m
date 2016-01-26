//
//  ZBookManager.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookManager.h"
#import "ZBookInfo.h"
#import "ZDBManager.h"
#import "ZTCPManager.h"

@implementation ZBookManager

+ (ZBookManager *)manager {
    static ZBookManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZBookManager alloc] init];
        
        NSDictionary* d = [[ZDBManager manager] getFontInfo];
        instance.fontSize = d[@"fontSize"];
        instance.lineSpace = d[@"lineSpace"];
        instance.paragraphSpace = d[@"paragraphSpace"];
        instance.wordSpace = d[@"wordSpace"];
        instance.fontFamily = d[@"fontFamily"];
    });
    
    return instance;
}



@end
