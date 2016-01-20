//
//  ZMessageSession.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMessageSession : NSObject

@property (nonatomic, copy) NSString* sessionID;
@property (nonatomic, copy) NSString* sessionType;
@property (nonatomic, copy) NSString* relationID;
@property (nonatomic, copy) NSString* receiverType;
@property (nonatomic, copy) NSString* unreadMsgCount;
@property (nonatomic, copy) NSString* modifyTime;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSString* draft;

@end
