//
//  BookMark.m
//  app_demo
//
//  Created by 张新伟 on 15/11/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "BookMark.h"

@implementation BookMark
- (id)initWith:(NSInteger)markid mark:(NSInteger)mark bookid:(NSInteger)bookid {
    self = [super init];
    if (self) {
        _markid = markid;
        _mark = mark;
        _bookid = bookid;
    }
    
    return self;
}
@end
