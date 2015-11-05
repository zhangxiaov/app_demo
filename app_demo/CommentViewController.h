//
//  CommentViewController.h
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;
@interface CommentViewController : UIViewController
@property (nonatomic, assign) NSInteger bookid;

- (instancetype)initWithBook:(Book *)book;
@end
