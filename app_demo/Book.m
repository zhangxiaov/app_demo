//
//  Book.m
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id)initWithName:(NSString *)bookname author:(NSString *)author profile:(NSString *)profile {
    self = [super init];
    if (self) {
        _bookname = bookname;
        _author = author;
        _profile = profile;
        _read = 0;
        _fontsize = 15;
        _pagepos = 0;
    }
    
    return self;
}

@end
