//
//  Comment.h
//  app_demo
//
//  Created by zhangxinwei on 15/11/23.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic) NSInteger commentId;
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic ,copy) NSString *date;
@property (nonatomic, copy) NSString *author;
@property (nonatomic) NSInteger bookId;
@end
