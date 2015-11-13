//
//  Book.h
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (nonatomic, assign) NSInteger bookid;
@property (nonatomic, assign) NSInteger read;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *profile;
@property (nonatomic, copy) NSString *bookname;
@property (nonatomic, assign) NSInteger fontsize;
@property (nonatomic, assign) NSInteger pagepos;
@property (nonatomic, assign) NSInteger len;

- (id)initWithName:(NSString *)bookname author:(NSString *)author profile:(NSString *)profile;
@end
