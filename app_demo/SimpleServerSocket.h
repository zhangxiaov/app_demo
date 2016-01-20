//
//  SimpleServerSocket.h
//  app_demo
//
//  Created by zhangxinwei on 15/12/2.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleServerSocket : NSObject
@property (nonatomic, copy) NSString *port;

- (instancetype)initWithPort:(NSString *)port;

- (BOOL)listen;
- (int)accept;

- (NSData *)getData:(int32_t)clientFd;
- (BOOL)sendData:(NSData *)data toClient:(int32_t)clientFd;

- (void)cliseSocket;

@end
