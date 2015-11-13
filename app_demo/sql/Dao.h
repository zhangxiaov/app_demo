//
//  SqlOP.h
//  app_demo
//
//  Created by 张新伟 on 15/10/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Book;

@interface Dao : NSObject
@property sqlite3 *db;

- (void)insertBook:(Book *)book;
- (void)updateBook:(Book *)book;
- (Book *)selectBook:(NSString *)name bookId:(NSInteger)bookId;

- (NSArray *)selectPages:(NSInteger)bookid fontSize:(NSInteger)fontSize;
- (void)insertPages:(NSInteger)bookid fontSize:(NSInteger)fontSize a:(NSArray *)a;

- (NSArray *)selectMarks:(NSInteger)bookid;
- (void)insertMarks:(NSInteger)bookid i:(NSInteger)i;

- (void)deleteMark:(NSInteger)markid;
- (void)deleteBook:(NSString *)name;

-(void)execSql:(NSString *)sql;
-(void)test;
@end
