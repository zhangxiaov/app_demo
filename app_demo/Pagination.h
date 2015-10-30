//
//  TextBuff.h
//  app_demo
//
//  Created by zhangxinwei on 15/10/26.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pagination : NSObject
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger len;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;
- (NSString *)strAtPos:(NSInteger)pos;
@end
