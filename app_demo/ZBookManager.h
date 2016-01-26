//
//  ZBookManager.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

@class ZBookInfo;
@interface ZBookManager : NSObject

+ (ZBookManager*)manager;

@property (nonatomic, copy) NSString* fontSize;
@property (nonatomic, copy) NSString* lineSpace;
@property (nonatomic, copy) NSString* paragraphSpace;
@property (nonatomic, copy) NSString* wordSpace;
@property (nonatomic, copy) NSString* fontFamily;

//书架信息 from db
- (NSArray*)getBookshelf;

//全文 db
- (NSString*)getBookContent;

//书库 若db无，取远程
- (NSArray*)getBookLibrary;

//书籍简介 db
- (ZBookInfo*)getBookInfo:(NSString*)bookID;

//短文 若db无 取远程
- (NSArray*)getEssay;

//短文详情 db
- (ZBookInfo*)getEssayInfo:(NSString*)essayID;

@end
