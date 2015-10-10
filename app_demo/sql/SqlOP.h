//
//  SqlOP.h
//  app_demo
//
//  Created by 张新伟 on 15/10/7.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqlOP : NSObject
@property sqlite3 *db;

-(void)execSql:(NSString *)sql;
-(void)test;
@end
