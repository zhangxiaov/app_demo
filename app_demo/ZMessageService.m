//
//  ZMessageService.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageService.h"
#import "ZMessageModel.h"

@implementation ZMessageService

+ (ZMessageService *)share {
    static ZMessageService* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZMessageService alloc] init];
    });
    
    return instance;
}

- (NSArray *)queryMessagesWithSeesionId:(NSString *)sessionID date:(NSString *)date limit:(NSInteger)limit {
    NSMutableArray* ma = [@[] mutableCopy];
    for (int i = 0; i < 20; i++) {
        ZMessageModel* msg = [[ZMessageModel alloc] init];
        msg.sessionID = @"1";
        msg.senderID = @"1001";
        msg.senderName = @"test";
        msg.receiverID = @"1002";
        msg.messageType = @"1";
        msg.text = [NSString stringWithFormat:@"teststetssttstststs%d", i];
        
        [ma addObject:msg];
    }
    
    return ma;
}

@end
