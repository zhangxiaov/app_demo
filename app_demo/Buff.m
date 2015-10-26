//
//  Buff.m
//  app_demo
//
//  Created by 张新伟 on 15/10/26.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "Buff.h"
#import "AppConfig.h"
#import <UIKit/UIKit.h>

@interface Buff ()
@property (nonatomic, assign) NSInteger buffSize;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) NSInteger fileLenth;
@property (nonatomic, strong) NSMutableArray *bytes;
@property (nonatomic, assign) NSInteger bufPos;//按可显示为字符串的字节位置
@property (nonatomic, assign) NSInteger fileOffset;
@property (nonatomic, strong) NSMutableArray *posArray;

@end

@implementation Buff

- (instancetype)initWithFileName:(NSString *)filename {
    self = [super init];
    if (self) {
        int lineCharsCount = floor(CONTENT_WIDTH / FONT_SIZE_CONTENT);
        int linesCount = floor(CONTENT_HEIGHT / FONT_SIZE_CONTENT);
        _buffSize = 4*lineCharsCount*linesCount;
        
        filename = [filename stringByAppendingPathExtension:@"txt"];
        _filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        _fileLenth = [fh seekToEndOfFile];
        
        _bytes = [[NSMutableArray alloc] initWithCapacity:_buffSize];
        _bufPos = 0;
        _fileOffset = 0;
        
        _posArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)readByOrder {
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    NSData *bytes = [fh readDataOfLength:_buffSize];
    
}

- (void)readByReverse {
    
}

static NSInteger bufPosFromBytes(NSData *data) {
    if (data.length == 0) {
        return 0;
    }
    
    unsigned long end = data.length - 1;
    char c = '\0';
    while (end > 0) {
        [data getBytes:&c range:NSMakeRange(end, sizeof(c))];
        if ((c & 0x40) == 0) {
            -- end;
        }else {
            [data getBytes:&c range:NSMakeRange(end, sizeof(c))];
            Byte b = c;
            int append = 0;
            
            if ((b & 0x80) == 0) {
                append += 0;
                break;
            }
            if ((b & 0x20) == 0) {
                append += 1;
                if (end + append + 1 <= data.length) {
                    end += append;
                }else {
                    end -= 1;
                }
                break;
            }
            if ((b & 0x10) == 0) {
                append += 2;
                if (end + append + 1 <= data.length) {
                    end += append;
                }else {
                    end -= 1;
                }
                break;
            }
            if ((b & 0x08) == 0) {
                append += 3;
                if (end + append + 1 <= data.length) {
                    end += append;
                }else {
                    end -= 1;
                }
                break;
            }
            if ((b & 0x04) == 0) {
                append += 4;
                if (end + append + 1 <= data.length) {
                    end += append;
                }else {
                    end -= 1;
                }
                break;
            }
            if ((b & 0x02) == 0) {
                append += 5;
                if (end + append + 1 <= data.length) {
                    end += append;
                }else {
                    end -= 1;
                }
                break;
            }
            
        }
    }
    
    return end;
}

@end
