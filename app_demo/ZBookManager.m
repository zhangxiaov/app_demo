//
//  ZBookManager.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookManager.h"
#import "ZBookInfo.h"
#import "ZDBManager.h"
#import "ZTCPManager.h"

@implementation ZBookManager

+ (ZBookManager *)manager {
    static ZBookManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZBookManager alloc] init];
    });
    
    return instance;
}

//书架信息 from db
- (NSArray*)getBookshelf {
    
}

//全文 db
- (NSString*)getBookContent {
    
}

//书库 若db无，取远程
- (NSArray*)getBookLibrary {
    
}

//书籍简介 db
- (ZBookInfo*)getBookInfo:(NSString*)bookID {
    
}

//短文 若db无 取远程
- (NSArray*)getEssay {
    
}

//短文 db
- (ZBookInfo*)getEssayInfo:(NSString*)essayID {
    
}

@end
