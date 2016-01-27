//
//  ZDBManager.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

@class ZBookInfo;
@interface ZDBManager : NSObject

+ (ZDBManager*)manager;

- (NSDictionary*)getFontInfo;

//取书架
- (NSArray*)getBookshelf;

//页码 字节索引
- (NSArray*)getPageIndexs:(NSString*)bookID;

//书籍简介 db
- (ZBookInfo*)getBookInfo:(NSString*)bookID;

- (void)updatefield:(NSString*)field  val:(NSString*)val bookID:(NSString*)bookID;

- (ZBookInfo*)getBookContent:(NSString*)bookID;
//取书库
- (NSArray*)getBookLibrary:(NSInteger)start limit:(NSInteger)limit;

@end
