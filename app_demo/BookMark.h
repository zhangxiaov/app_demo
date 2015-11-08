//
//  BookMark.h
//  app_demo
//
//  Created by 张新伟 on 15/11/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookMark : NSObject
@property (nonatomic, assign) NSInteger markid;
@property (nonatomic, assign) NSInteger mark;
@property (nonatomic, assign) NSInteger bookid;

- (id)initWith:(NSInteger)markid mark:(NSInteger)mark bookid:(NSInteger)bookid;
@end
