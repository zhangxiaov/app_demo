//
//  SqlOP.m
//  app_demo
//
//  Created by 张新伟 on 15/10/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "Dao.h"
#import "Book.h"
#import "bookMark.h"

#define DBNAME    @"bookinfo.sqlite"

@implementation Dao

- (instancetype)init {

    [self open];
    [self create];
    sqlite3_close(_db);
    return self;
}

- (void)open {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = paths[0];
    NSString *dbpath = [doc stringByAppendingPathComponent:DBNAME];
    
    NSLog(@"dbpath = %@", dbpath);

    if (sqlite3_open([dbpath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"open db failed");
    }
}

- (void)close {
    sqlite3_close(_db);
}

-(void)execSql:(NSString *)sql {
    char *err;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库操作数据失败");
    }
}

- (void)create {
    //NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";

    NSString *sbooks = @"create table if not exists table_books (bookid integer primary key autoincrement,name text, read integer,author text,profile text,len integer)";
    NSString *spages14 = @"create table if not exists table_pages14 (pages text, bookid integer)";
    NSString *spages15 = @"create table if not exists table_pages15 (pages text, bookid integer)";
    NSString *scomments = @"create table if not exists table_comments (commentid integer,content text,date text,username text, bookid integer)";
    NSString *sdirs = @"create table if not exists table_dirs (dirs text, bookid integer)";
    NSString *smarks = @"create table if not exists table_marks (markid integer primary key autoincrement,mark integer, bookid integer)";
    
    char *s = "insert into table_pages14 (pages, bookid) values (?,?)";
    char *s2 = "insert into table_comments (content, date, username, bookid) values (?, ?)";
    char *s3 = "insert into table_dirs (dirs, bookid) values (?, ?)";
    char *s4 = "insert into table_marks (mark, bookid) values(?, ?)";
    
    char *ss = "update table_pages14 set pages=? where bookid=?";
    char *ss2 = "update table_comments set content=?,date=?,username=? where bookid = ?";
    char *ss3 = "update table_dirs set dirs = ? where bookid = ?";
    char *ss4 = "update table_marks set mark = ? where bookid = ?";
    
    char *sss= "delete from table_books where bookid = ?";
    char *sss1 ="delete from table_pages14 where bookid = ?";
    char *sss2 = "delete from table_comments where  bookid = ?";
    char *sss3 = "delete from table_marks where bookid = ?";
    char *sss4 = "delete from table_dirs where bookid = ?";
    
    char *st = "select * from table_books where id = ?";
    char *st1 = "select * from table_pages14 where bookid = ?";
    char *st2 = "select * from table_comments where bookid = ?";
    char *st3 = "select * from table_marks where bookid = ?";
    char *st4 = "select * from table_dirs where bookid = ?";
    
    
    
    [self execSql:sbooks];
    [self execSql:spages14];
    [self execSql:spages15];
    [self execSql:scomments];
    [self execSql:sdirs];
    [self execSql:smarks];
    
    sqlite3_close(_db);
}

- (void)insertBook:(Book *)book {
    NSString *s =[NSString stringWithFormat:@"insert into table_books (name, read, author, profile, len) values ('%@',%ld,'%@','%@',%ld)",book.bookname,book.read,book.author,book.profile,book.len];
    char *err;
    
    [self open];
    if (sqlite3_exec(_db, [s UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed %@", s, [NSString stringWithUTF8String:err]);
        return;
    }
    
    book.bookid = sqlite3_last_insert_rowid(_db);
    sqlite3_close(_db);
}

- (void)updateBook:(Book *)book {
    char *s = "update table_books set name=?,read=?,author=?,profile=?,len=? where id=?";
    
    [self open];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, s, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [book.bookname UTF8String], -1, nil);
        sqlite3_bind_int64(stmt, 2, book.read);
        sqlite3_bind_text(stmt, 3, [book.author UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [book.profile UTF8String], -1, nil);
        sqlite3_bind_int64(stmt, 5, book.len);
        sqlite3_bind_int64(stmt, 6, book.bookid);
    }
    
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_close(_db);
        NSLog(@"数据库操作数据失败 updatebook");
        return;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(_db);
}

- (Book *)selectBook:(NSString *)name bookId:(NSInteger)bookId {
    Book *book;
    NSString *s;
    if(bookId <= 0) {
        if (name && name.length >0) {
            book = [[Book alloc] init];
            s = [NSString stringWithFormat:@"select * from table_books where name = '%@' limit 1", name];
        }
    }else {
        book = [[Book alloc] init];
        s = [NSString stringWithFormat:@"select * from table_books where bookid = %ld limit 1", bookId];
    }
    
    [self open];
    sqlite3_stmt *stmt;
    int state = sqlite3_prepare_v2(_db, [s UTF8String], -1, &stmt, nil);
    if (state == SQLITE_OK) {
        
    }
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSInteger bookid = sqlite3_column_int64(stmt, 0);
        char *name = (char *)sqlite3_column_text(stmt, 1);
        NSInteger read = sqlite3_column_int64(stmt, 2);
        char *author = (char *)sqlite3_column_text(stmt, 3);
        char *profile = (char *)sqlite3_column_text(stmt, 4);
        NSInteger len = sqlite3_column_int64(stmt, 5);
        
        book.bookid = bookid;
        book.bookname = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        book.read = read;
        book.author = [NSString stringWithCString:author encoding:NSUTF8StringEncoding];
        book.profile = [NSString stringWithCString:profile encoding:NSUTF8StringEncoding];
        book.len = len;
    }
    
    sqlite3_finalize(stmt);
    
    [self close];
    return book;
}

- (NSArray *)selectPages:(NSInteger)bookid fontSize:(NSInteger)fontSize {
    NSString *s = [NSString stringWithFormat:@"select pages from table_pages%ld where bookid = %ld", fontSize, bookid];
    
    [self open];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, [s UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed", s);
        return nil;
    }

    NSArray *a;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        char *s = (char *)sqlite3_column_text(stmt, 0);
        a = [[NSString stringWithUTF8String:s] componentsSeparatedByString:@","];
    }
    
    [self close];
    return a;
}

- (void)insertPages:(NSInteger)bookid fontSize:(NSInteger)fontSize a:(NSArray *)a {
    NSString *pages = [a componentsJoinedByString:@","];
    NSString *s = [NSString stringWithFormat:@"insert into table_pages%ld (pages,bookid) values('%@', %ld)", fontSize, pages, bookid];
    
    [self open];
    if (sqlite3_exec(_db, [s UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed", s);
        return;
    }
    
    [self close];
}

- (NSArray *)selectMarks:(NSInteger)bookid {
    NSString *s = [NSString stringWithFormat:@"select * from table_marks where bookid = %ld", bookid];
    
    [self open];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, [s UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed", s);
        return nil;
    }
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSInteger markid = sqlite3_column_int64(stmt, 0);
        NSInteger mark = sqlite3_column_int64(stmt, 1);
        NSInteger bookid = sqlite3_column_int64(stmt, 2);
        BookMark *bookMark = [[BookMark alloc] initWith:markid mark:mark bookid:bookid];
        [a addObject:bookMark];
    }
    
    [self close];
    return a;
}

- (void)insertMarks:(NSInteger)bookid i:(NSInteger)i{
    NSString *s = [NSString stringWithFormat:@"insert into table_marks (mark,bookid) values(%ld, %ld)", i, bookid];
    
    [self open];
    if (sqlite3_exec(_db, [s UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed", s);
        return;
    }
    
    [self close];
}

- (void)deleteMark:(NSInteger)markid {
    NSString *s = [NSString stringWithFormat:@"delete from table_marks where markid = %ld", markid];
    
    [self open];
    if (sqlite3_exec(_db, [s UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"%@ : failed", s);
        return;
    }
    
    [self close];
}

- (void)deleteBook:(NSString *)name {
    NSString *s = [NSString stringWithFormat:@"select bookid from table_books where name = %@", name];
    
    [self open];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, [s UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"delete book failed");
        return;
    }
    
    NSInteger bookid = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        bookid = sqlite3_column_int64(stmt, 0);
    }
    
    NSString *s1 = [NSString stringWithFormat:@"delete from table_books where bookid = %ld", bookid];
    NSString *s2 = [NSString stringWithFormat:@"delete from table_pages14 where bookid = %ld", bookid];
    NSString *s3 = [NSString stringWithFormat:@"delete from table_comments where bookid = %ld", bookid];
    NSString *s4 = [NSString stringWithFormat:@"delete from table_marks where bookid = %ld", bookid];
    NSString *s5 = [NSString stringWithFormat:@"delete from table_dirs where bookid = %ld", bookid];

    if (sqlite3_exec(_db, [s1 UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"%@ : failed", s1);
    }
    
    if (sqlite3_exec(_db, [s2 UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"%@ : failed", s2);
    }
    
    if (sqlite3_exec(_db, [s3 UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"%@ : failed", s3);
    }
    
    if (sqlite3_exec(_db, [s4 UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"%@ : failed", s4);
    }
    
    if (sqlite3_exec(_db, [s5 UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"%@ : failed", s5);
    }
    
    sqlite3_close(_db);
}

-(void)test {
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * stmt;
    
    if (sqlite3_prepare_v2(_db, [sqlQuery UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(stmt, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(stmt, 2);
            
            char *address = (char*)sqlite3_column_text(stmt, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(_db);
}

@end
