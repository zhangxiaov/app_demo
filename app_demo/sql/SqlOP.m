//
//  SqlOP.m
//  app_demo
//
//  Created by 张新伟 on 15/10/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "SqlOP.h"

#define DBNAME    @"info.sqlite"


@implementation SqlOP

- (instancetype)init {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = paths[0];
    NSString *dbpath = [doc stringByAppendingString:DBNAME];
    
    if (sqlite3_open([dbpath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"open db failed");
    }
    
    return nil;
}

-(void)execSql:(NSString *)sql {
    char *err;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库操作数据失败1i c  ");
    }
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [self execSql:sqlCreateTable];
}

@end
