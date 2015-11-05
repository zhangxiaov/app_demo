//
//  CommentViewController.m
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "CommentViewController.h"
#import "Book.h"

@implementation CommentViewController

- (instancetype)initWithBook:(Book *)book
{
    self = [super init];
    if (self) {
        self.title = @"评论";
    }
    return self;
}

@end
