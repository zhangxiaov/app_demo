//
//  ZBookContentViewController.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//


@class ZBookInfo;
@interface ZBookContentViewController : UIViewController
@property (nonatomic, strong) ZBookInfo* bookInfo;
- (instancetype)initWith:(ZBookInfo*)bookInfo;
@end
