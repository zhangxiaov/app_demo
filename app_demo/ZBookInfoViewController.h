//
//  ZBookInfoViewController.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBookInfo;
@interface ZBookInfoViewController : UIViewController

@property (nonatomic, strong) ZBookInfo* bookInfo;

- (instancetype)initWithBook:(ZBookInfo*)bookInfo;

@end
