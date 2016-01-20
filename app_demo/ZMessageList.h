//
//  ZMessageList.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZMessageModel;
@class ZMessageList;
@class ZMessageSession;

@protocol ZMessageListDelegate <NSObject>
@required
- (void)list:(ZMessageList *)list didRequestLatestMessages:(NSArray *)messages;
- (void)list:(ZMessageList *)list didRequestFormerMessages:(NSArray *)messages;
- (void)list:(ZMessageList *)list didPushedWithMessages:(NSArray *)messages;

@end

@interface ZMessageList : NSObject
@property (nonatomic, strong, readonly) NSMutableArray* messages;
@property (nonatomic, weak) id<ZMessageListDelegate> delegate;

//初始化
- (instancetype)initWithSession:(ZMessageSession* )session
                       delegate:(id<ZMessageListDelegate>)delegate;

//取以前的消息
- (BOOL)fetchFormerMessages;

//取最新消息
- (BOOL)fetchLatestMessages;

//发消息
- (void)sendMessage:(ZMessageModel *)message;

//删除消息
- (void)deleteMessage:(ZMessageModel *)message;

//重发消息
- (void)reSendMessage:(ZMessageModel *)message;

@end
