//
//  ZDBManager.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase/FMDatabase.h>

@class ZBookInfo;
@interface ZDBManager : NSObject

+ (ZDBManager*)manager;

//取书架
- (NSArray*)getBookshelf;

//书籍简介 db
- (ZBookInfo*)getBookInfo:(NSString*)bookID;

- (void)updatefield:(NSString*)field  val:(NSString*)val bookID:(NSString*)bookID;

- (ZBookInfo*)getBookContent:(NSString*)bookID;
//取书库
- (NSArray*)getBookLibrary:(NSInteger)start limit:(NSInteger)limit;

@end
