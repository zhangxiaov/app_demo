//
//  Buff.h
//  app_demo
//
//  Created by 张新伟 on 15/10/26.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Buff : NSObject
- (void)readByOrder;
- (void)readByReverse;
- (void)colse;
- (instancetype)initWithFileName:(NSString *)filename;
- (void)rect:(CFRange)r;
@end
