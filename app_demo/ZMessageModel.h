//
//  ZMessageModel.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMessageModel : NSObject
@property (nonatomic, copy) NSString* sessionID;
@property (nonatomic, copy) NSString* senderID;
@property (nonatomic, copy) NSString* senderName;
@property (nonatomic, copy) NSString* receiverID;

@property (nonatomic) NSInteger messageType;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) NSData* imageData;
@end
