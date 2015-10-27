//
//  TextBuff.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/26.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "TextBuff.h"

@implementation TextBuff

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSInteger bytecount = 1000000;
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:@"filepath"];
        NSData *data = [fh readDataOfLength:bytecount];
        
        if (data.length == bytecount) {
            char c = '\0';
            NSInteger pos = bytecount - 1;
            while (true) {
                [data getBytes:&c range:NSMakeRange(pos, 1)];
                if ((c & 0x80) == 0) {
                    break;
                }else if ((c & 0x40) == 0) {
                    
                }else if ((c & 0x20) == 0) {
                    pos--;
                    break;
                }else if ((c & 0x10) == 0) {
                    pos--;
                    break;
                }else if ((c & 0x08) == 0) {
                    pos--;
                    break;
                }else if ((c & 0x04) == 0) {
                    pos--;
                    break;
                }else if ((c & 0x02) == 0) {
                    pos--;
                    break;
                }
            }

        }
    }
    return self;
}



@end
