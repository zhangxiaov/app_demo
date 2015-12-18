//
//  SkViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/2.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "SkViewController.h"
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/signal.h>
#include <sys/time.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/event.h>
#include <err.h>

@implementation SkViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)test {
    int fd, kq, n;
    int argc;
    char **argv;
    struct kevent event[2];
    char buffer[128];
    struct timespec nullts = { 0, 0 };
    int fdout = 1;
    
    if (argc != 2)
        errx(1, "Usage: %s net_device\n", argv[0]);
    
    fd = open(argv[1], O_RDWR);
    if (fd == -1)
        err(1, "open(%s)", argv[1]);
    
    kq = kqueue();
    if (kq < 0)
        err(1, "kqueue");
    
//    EV_SET(&event[0], fd, EVFILT_NETDEV, EV_ADD | EV_CLEAR,
//           NOTE_LINKUP | NOTE_LINKDOWN | NOTE_LINKINV, 0, 0);
//    n = kevent(kq, event, 1, NULL, 0, &nullts);
//    if (n == -1)
//        err(1, "kevent");
//    
//    for (;;) {
//        n = kevent(kq, NULL, 0, event, 1, NULL);
//        if (n < 0)
//            err(1, "kevent");
//        printf("fflags: 0x%x\n", event[0].fflags);
//        printf("Link");
//        if (event[0].fflags & NOTE_LINKUP)
//            printf(" up");
//        if (event[0].fflags & NOTE_LINKDOWN)
//            printf(" down");
//        if (event[0].fflags & NOTE_LINKINV)
//            printf(" indeterminate");
//        printf("\n");
//    }
//    
//    return (0);
}

@end
