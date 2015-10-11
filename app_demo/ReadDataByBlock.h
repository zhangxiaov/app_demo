//
//  ReadFileByBlock.h
//  app_demo
//
//  Created by 张新伟 on 15/10/8.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReadDataByBlock : NSObject
@property (nonatomic, assign) NSData *data;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) unsigned long long dataPosition;
@property (nonatomic, assign) unsigned long long dataLen;
@property (nonatomic, assign) int byteLenForZh;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) int possibleTotalPages;

- (instancetype)initWithTitle:(NSString *)title ;
- (NSString *)dataAtPos:(unsigned long long)pos isReverse:(BOOL)isReverse;
@end
