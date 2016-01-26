//
//  ZSetting.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSetting : NSObject
@property (nonatomic) int fontSize;
@property (nonatomic, copy) NSString* fontFamily;

//据字长 分页 存入db
- (void)paging:(NSString*)bookID fontSize:(int)fontSize;

@end
