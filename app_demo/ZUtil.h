//
//  ZUtil.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

@interface ZUtil : NSObject


+ (CGFloat)heightForText:(NSString*)text attr:(NSDictionary*)dict;

//据字长 分页 存入db
+ (void)paging:(NSString *)bookID;

@end
