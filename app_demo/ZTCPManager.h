//
//  ZTCPManager.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

typedef void(^ZTCPBlock)(id responseObj, NSError* error);

@class ZMessageModel;
@interface ZTCPManager : NSObject

//取书库
- (void)pullBookLibrary:(NSInteger)start limit:(NSInteger)limit completeBlock:(ZTCPBlock)completeBlock;

//下载书
- (void)downloadBook:(NSString*)bookID completeBlock:(ZTCPBlock)completeBlock;

//取书评
- (void)pullMessage:(NSInteger)start limit:(NSInteger)limit completeBlock:(ZTCPBlock)completeBlock;

//发消息
- (void)pushMessage:(ZMessageModel*)message completeBlock:(ZTCPBlock)completeBlock;

//取短文
- (void)pullEssay:(NSInteger)start limit:(NSInteger)limit completeBlock:(ZTCPBlock)completeBlock;

@end
