//
//  ZDBManager.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZDBManager.h"
#import "ZBookInfo.h"

@interface ZDBManager ()
@property (nonatomic, strong) FMDatabase* db;
@end

@implementation ZDBManager

+ (ZDBManager *)manager {
    static ZDBManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZDBManager alloc] init];
        instance.db = [FMDatabase databaseWithPath:[instance getDBPath]];
        [instance createTables];
    });
    
    return instance;
}

- (NSDictionary*)getFontInfo {
    NSDictionary* dict = @{@"fontSize":@"",@"lineSpace":@"",@"paragraphSpace":@"",@"wordSpace":@"",@"fontFamily":@""};
    NSString* sql = @"select fontSize, lineSpace, paragraphSpace, wordSpace, fontFamily from t_fontInfo";
    FMResultSet* rs = [[ZDBManager manager].db executeQuery:sql];
    while ([rs next]) {
        [dict setValue:[rs stringForColumn:@"fontSize"] forKey:@"fontSize"];
        [dict setValue:[rs stringForColumn:@"lineSpace"] forKey:@"lineSpace"];
        [dict setValue:[rs stringForColumn:@"paragraphSpace"] forKey:@"paragraphSpace"];
        [dict setValue:[rs stringForColumn:@"wordSpace"] forKey:@"wordSpace"];
        [dict setValue:[rs stringForColumn:@"fontFamily"] forKey:@"fontFamily"];
    }
    
    return dict;
}

//取书架,并按阅日 排序
- (NSArray*)getBookshelf {
    NSMutableArray* books = [@[] mutableCopy];
//    NSString* sql = @"select book_id,book_name,book_icon,book_pages,book_progress,book_lastDate from t_bookshelf";
//    FMResultSet* rs = [[ZDBManager manager].db executeQuery:sql];
//    while ([rs next]) {
//        ZBookInfo* bookInfo = [[ZBookInfo alloc] init];
//        bookInfo.bookID = [rs stringForColumn:@"book_id"];
//        bookInfo.bookName = [rs stringForColumn:@"book_name"];
//        bookInfo.bookIcon = [rs stringForColumn:@"book_icon"];
//        bookInfo.pages = [rs stringForColumn:@"book_pages"];
//        bookInfo.progress = [rs stringForColumn:@"book_progress"];
//        bookInfo.lastDate = [rs intForColumn:@"book_lastDate"];
//        
//        [books addObject:bookInfo];
//    }
    
    for (int i = 0; i < 11; i++) {
        ZBookInfo* bookInfo = [[ZBookInfo alloc] init];
        bookInfo.bookID = @"1";
        bookInfo.bookName = @"test";
        bookInfo.bookIcon = @"MISAskAddFile";
        bookInfo.pages = @"11";
        bookInfo.progress = @"0";
        bookInfo.lastDate = 0;
        
        [books addObject:bookInfo];
    }
    
    
    [books sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ZBookInfo* b1 = obj1;
        ZBookInfo* b2 = obj2;
        
        return b1.lastDate > b2.lastDate;
    }];
    
    return books;
}

//书籍简介 db
- (ZBookInfo*)getBookInfo:(NSString*)bookID {
    ZBookInfo* bookInfo;
    NSString* sql = @"select book_id,book_name,book_icon,book_pages,book_progress,book_lastDate,book_profile from t_bookshelf where book_id = ?";
    FMResultSet* rs = [[ZDBManager manager].db executeQuery:sql, bookID];
    while ([rs next]) {
        bookInfo = [[ZBookInfo alloc] init];
        bookInfo.bookID = [rs stringForColumn:@"book_id"];
        bookInfo.bookName = [rs stringForColumn:@"book_name"];
        bookInfo.bookIcon = [rs stringForColumn:@"book_icon"];
        bookInfo.pages = [rs stringForColumn:@"book_pages"];
        bookInfo.progress = [rs stringForColumn:@"book_progress"];
        bookInfo.lastDate = [rs intForColumn:@"book_lastDate"];
        bookInfo.bookProfile = [rs stringForColumn:@"book_profile"];
    }
    
    return bookInfo;
}

- (void)updatefield:(NSString*)field  val:(NSString*)val bookID:(NSString*)bookID  {
    NSString* sql = [NSString stringWithFormat:@"update t_bookshelf set %@ = ? where book_id = ?", field];
    [[ZDBManager manager].db executeUpdate:sql, val, bookID];
}

- (ZBookInfo*)getBookContent:(NSString*)bookID {
    ZBookInfo* bookInfo;
    NSString* sql = @"select book_id,book_name,book_pages,book_progress,book_content from t_bookshelf where book_id = ?";
    FMResultSet* rs = [[ZDBManager manager].db executeQuery:sql, bookID];
    while ([rs next]) {
        bookInfo = [[ZBookInfo alloc] init];
        bookInfo.bookID = [rs stringForColumn:@"book_id"];
        bookInfo.bookName = [rs stringForColumn:@"book_name"];
        bookInfo.pages = [rs stringForColumn:@"book_pages"];
        bookInfo.progress = [rs stringForColumn:@"book_progress"];
        bookInfo.bookContent = [rs stringForColumn:@"book_content"];
    }
    
    return bookInfo;
}

- (NSString*)getDBPath {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingPathComponent:@"bookDB.sqlite"];
}

//表不在 新建
- (void)createTables {
    [[ZDBManager manager].db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_bookshelf \
     (book_id INTEGER PRIMARY KEY, \
     book_name text, \
     book_author text, \
     book_icon text, \
     book_profile text, \
     book_pages text, \
     book_progress text, \
     book_lastDate integer, \
     book_byteIndexs_15 text, \
     book_byteIndexs_16 text, \
     book_byteIndexs_17 text, \
     book_byteIndexs_18 text, \
     book_byteIndexs_19 text, \
     book_byteIndexs_20 text, \
     book_charCount text)"];
    
    [[ZDBManager manager].db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_bookLibrary \
     (book_id INTEGER PRIMARY KEY, \
     book_name text, \
     book_author text, \
     book_icon text, \
     book_profile text"];
    
    [[ZDBManager manager].db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_fontInfo \
     (fontSize text, \
     lineSpace text, \
     paragraphSpace text, \
     wordSpace text, \
     fontFamily text"];
}

//表在否
- (BOOL)isTableExist:(NSString*)tableName {
    NSString* sql = @"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?";
    FMResultSet* result = [[ZDBManager manager].db executeQuery:sql, tableName];
    
    while ([result next]) {
        NSInteger count = [result intForColumn:@"count"];
        if (0 == count) {
            return NO;
        }
    }
    
    return YES;
}

@end
