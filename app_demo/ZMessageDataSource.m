//
//  ZMessageDataSource.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageDataSource.h"
#import "ZMessageList.h"

@interface ZMessageDataSource()
@property (nonatomic, strong) NSCache* heightCache;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, weak) ZMessageList* model;
@property (nonatomic, weak) id <ZMessageListDelegate> delegate;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ZMessageDataSource

- (instancetype)initWithModel:(ZMessageList *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

@end
