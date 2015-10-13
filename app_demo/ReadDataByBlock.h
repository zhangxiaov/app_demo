//
//  ReadFileByBlock.h
//  app_demo
//
//  Created by 张新伟 on 15/10/8.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReadDataByBlock : NSObject
//@property (nonatomic, assign) NSData *data;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) unsigned long long dataPosition;
@property (nonatomic, assign) unsigned long long dataLen;
@property (nonatomic, assign) int oneLabelBytes;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) int possibleTotalPages;
@property (nonatomic, strong) NSMutableArray *posArray;


//@property (nonatomic, strong) NSArray *array;

- (instancetype)initWithTitle:(NSString *)title ;
- (NSString *)strForPage:(int)page isReverse:(BOOL)isReverse;
@end
