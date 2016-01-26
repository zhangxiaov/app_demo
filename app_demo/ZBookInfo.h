//
//  ZBookInfo.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

@interface ZBookInfo : NSObject
@property (nonatomic, copy) NSString* bookID;
@property (nonatomic, copy) NSString* bookIcon;
@property (nonatomic, copy) NSString* bookAuthor;
@property (nonatomic, copy) NSString* bookName;
@property (nonatomic, copy) NSString* bookProfile;
@property (nonatomic, copy) NSString* bookContent;

@property (nonatomic) NSInteger charCount;

@property (nonatomic, copy) NSString* pages;
@property (nonatomic, copy) NSString* progress;

@property (nonatomic) NSInteger lastDate;
@end
