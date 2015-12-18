//
//  SimpleServerSocket.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/2.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "SimpleServerSocket.h"
#include <netdb.h>

#define ERR(errno,str) [[NSError alloc] initWithDomain:@"SimpleClientSockDomain" code:(errno) userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:(str)] forKey:NSLocalizedDescriptionKey]];


@interface SimpleServerSocket ()
@property (nonatomic) int32_t fd;
@property (nonatomic, strong) NSError *err;
@end

@implementation SimpleServerSocket

- (instancetype)initWithPort:(NSString *)port
{
    self = [super init];
    if (self) {
        _port = port;
    }
    
    return self;
}

- (BOOL)listen {
    
    struct addrinfo hints, *serverInfo;
    bzero(&hints, sizeof(hints));
    
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    int error = getaddrinfo(NULL, [_port UTF8String], &hints, &serverInfo);
    if (error) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    
    _fd = socket(AF_INET, SOCK_STREAM, 0);
    if (_fd < 0) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    
    int error_bind = bind(_fd, serverInfo->ai_addr, serverInfo->ai_addrlen);
    if (error_bind < 0) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    
    if (listen(_fd, 10) == -1) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);

        return false;
    }
    
    return true;
}

- (int)accept {
    struct sockaddr_storage remoteAddr;
    int clientFd = accept(_fd, (struct sockaddr *)&remoteAddr, &(socklen_t){sizeof(remoteAddr)});
    if (clientFd == -1) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);
        return 0;
    }
    
    return clientFd;
}

- (NSData *)getData:(int32_t)clientFd {
    int32_t len = 1024;
    long count;
    NSMutableData *md = [[NSMutableData alloc] init];
    
    while (true) {
        char buf[len];
        count = recv(clientFd, &buf, sizeof(buf), 0);
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

- (BOOL)sendData:(NSData *)data toClient:(int32_t)clientFd {
    long len = data.length;
    long count = send(clientFd, [data bytes], len, 0);
    if (count < 0) {
        _err = ERR(errno, strerror(errno));
        NSLog(@"%@", _err.localizedDescription);
        return false;
    }
    return true;
}


- (void)cliseSocket {
    if (_fd > 0) {
        close(_fd);
    }
    
    _fd = 0;
}

@end
