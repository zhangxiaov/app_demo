//
//  ZMessageService.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMessageService : NSObject

+ (ZMessageService*)share;

- (NSArray*)queryMessagesWithSeesionId:(NSString*)sessionId date:(NSString*)date limit:(NSInteger)limit;

@end
