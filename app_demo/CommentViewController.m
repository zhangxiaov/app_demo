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
        self.navigationController.navigationBarHidden = NO;
        self.title = @"评论";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)back {
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
