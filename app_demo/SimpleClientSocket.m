//
//  SimpleClientSocket.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/2.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "SimpleClientSocket.h"
#include <sys/socket.h>
#include <netdb.h>

#define ERR(errno,str) [[NSError alloc] initWithDomain:@"SimpleClientSockDomain" code:(errno) userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:(str)] forKey:NSLocalizedDescriptionKey]];

@interface SimpleClientSocket ()
@property (nonatomic) int32_t fd;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *port;
@end

@implementation SimpleClientSocket

- (instancetype)initWithHost:(NSString *)host port:(NSString *)port
{
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
    }
    return self;
}

- (BOOL)connectWithTimeOut:(int32_t)time {
    
    return nil;
}

- (BOOL)connect {
    
    struct addrinfo hints, *serverInfo;
    bzero(&hints, sizeof(hints));
    
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    int err = getaddrinfo([_host UTF8String], [_port UTF8String], &hints, &serverInfo);
    if (err) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);
        return false;
    }
    
    _fd = socket(AF_INET, SOCK_STREAM, 0);
    if (_fd == -1) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    
    if (connect(_fd, serverInfo->ai_addr, serverInfo->ai_addrlen) < 0) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);
        return false;
    }
    
    
    
    return false;
}

- (NSData *)getData {
    int32_t len = 1024;
    long count;
    NSMutableData *md = [[NSMutableData alloc] init];
    
    while (true) {
        char buf[len];
        count = recv(_fd, &buf, sizeof(buf), 0);
        if (count <= 0) {
            _err = ERR(errno, strerror(errno));
            NSLog(@"%@", _err.localizedDescription);
            break;
        }
        
        if (errno == EAGAIN) {
            break;
        }
        
        if (count != len) {
            [md appendBytes:buf length:count];
            break;
        }else {
            [md appendBytes:buf length:len];
        }
    }
    
    return md;
}

- (BOOL)sendData:(NSData *)data {
    long len = data.length;
    char *buf = [data bytes];
//    [data getBytes:buf length:sizeof(char)];
    
    long count = send(_fd, buf, len, 0);
    if (count < 0) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    return true;
}

- (void)closeSocket {
    if (_fd > 0) {
        close(_fd);
    }
    
    _fd = 0;
}
@end
