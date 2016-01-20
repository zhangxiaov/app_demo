//
//  SimpleClientSocket.h
//  app_demo
//
//  Created by zhangxinwei on 15/12/2.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleClientSocket : NSObject
- (NSData *)getDataWithUrl:(NSURL *)url;
@property (nonatomic, strong) NSError *err;

- (instancetype)initWithHost:(NSString *)host port:(NSString *)port;

- (BOOL)connectWithTimeOut:(int32_t)time;
- (BOOL)connect;

- (NSData *)getData;
- (BOOL)sendData:(NSData *)data;

- (void)closeSocket;
@end
