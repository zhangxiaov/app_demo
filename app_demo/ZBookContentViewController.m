//
//  ZBookContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookContentViewController.h"
#import "ZBookInfo.h"
#import "ZDBManager.h"

@interface ZBookContentViewController () <UIScrollViewDelegate>

@end

@implementation ZBookContentViewController

- (instancetype)initWith:(ZBookInfo*)bookInfo
{
    self = [super init];
    if (self) {
        _bookInfo = [[ZDBManager manager] getBookContent:bookInfo.bookID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)prepareData {
    
}

- (void)placeViews {
    
}

@end
