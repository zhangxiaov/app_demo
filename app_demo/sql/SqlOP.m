//
//  SqlOP.m
//  app_demo
//
//  Created by 张新伟 on 15/10/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "SqlOP.h"

#define DBNAME    @"info.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"

@implementation SqlOP

- (instancetype)init {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = paths[0];
    NSString *dbpath = [[doc stringByAppendingString:@"/"] stringByAppendingString:DBNAME];
    
    if (sqlite3_open([dbpath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"open db failed");
    }
    
    return self;
}

-(void)execSql:(NSString *)sql {
    char *err;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库操作数据失败1i c  ");
    }
}

-(void)test {
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(_db);
}

@end
