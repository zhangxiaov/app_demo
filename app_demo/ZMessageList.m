//
//  ZMessageList.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageList.h"
#import "ZMessageService.h"
#import "ZMessageSession.h"
#import "ZMessageModel.h"

@interface ZMessageList ()
@property (nonatomic, strong) ZMessageSession* session;
@property (nonatomic, strong) NSMutableArray* messages;
@end

@implementation ZMessageList

- (instancetype)initWithSession:(ZMessageSession *)session delegate:(id<ZMessageListDelegate>)delegate
{
    self = [super init];
    if (self) {
        _session = session;
        _delegate = delegate;
        _messages = [@[] mutableCopy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didMessageDataChangedNotification:) name:@"ZMessageDataChangedNotification" object:nil];
    }
    return self;
}

- (BOOL)fetchFormerMessages {
    return YES;
}

- (BOOL)fetchLatestMessages {
    NSArray* array = [[ZMessageService share] queryMessagesWithSeesionId:self.session.sessionID date:nil limit:10];
    
    if (array.count > 0) {
        //追加到头上
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(0, array.count)];
        [self.messages insertObjects:array atIndexes:indexes];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(list:didRequestLatestMessages:)]) {
                [self.delegate list:self didRequestLatestMessages:array];
            }
        });
        
        return YES;
    }
    
    return NO;
}

- (void)sendMessage:(ZMessageModel *)message {
    [self.messages addObject:message];
}

#pragma mark event

- (void)didMessageDataChangedNotification:(NSNotification*)notification {
    
}

@end
