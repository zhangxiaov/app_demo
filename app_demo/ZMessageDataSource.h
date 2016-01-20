//
//  ZMessageDataSource.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZMessageList;

@interface ZMessageDataSource : NSObject<UITableViewDataSource>
//初始化
- (instancetype)initWithModel:(ZMessageList *)model;
//                     delegate:(id<ZMessageListDelegate>)delegate;

//重新装载
- (void)reloadItemsWithCompletion:(void(^)(void))completion;

- (void)insertObjs:(NSArray *)objs completion:(void(^)(CGFloat yOffset))completion;

//查找对象
- (NSIndexSet *)indexesWithObj:(id)obj;

//添加对象
- (NSArray *)indexPathsAfterAddObj:(id)obj;
- (NSArray *)indexPathsAfterAddObjs:(NSArray *)objs;

//删除对象
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;


//获取Cell高度
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
