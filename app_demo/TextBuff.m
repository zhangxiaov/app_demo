//
//  TextBuff.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/26.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "TextBuff.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@implementation TextBuff

- (instancetype)init
{
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
        BOOL is = false;
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [[resourcePath stringByAppendingPathComponent:@"test"] stringByAppendingPathExtension:@"txt"];
        
//        NSString *tmpstr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        bool ishaven = [tmpstr containsString:@"\r"];
//        tmpstr = [tmpstr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        [tmpstr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSInteger bytecount = 100000;
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSInteger len = [fh seekToEndOfFile];
        [fh seekToFileOffset:0];
        NSInteger byteOffset = 0;
        
        while ([fh offsetInFile] < len) {
            
            if (byteOffset > 0) {
                is = true;
                byteOffset = ((NSNumber *)_array[_array.count - 1]).integerValue;
                [fh seekToFileOffset: byteOffset];
            }
            
            NSData *data = [fh readDataOfLength:bytecount];
            NSInteger offset = [fh offsetInFile];
            NSInteger pos = 0;
            
            if (data.length == bytecount) {

                char c = '\0';
                NSInteger n = 0;
                pos = bytecount - 1;
                while (true) {
                    [data getBytes:&c range:NSMakeRange(pos, 1)];
                    if ((c & 0x80) == 0) {
                        break;
                    }else if ((c & 0x40) == 0) {
                        pos--;
                        n++;
                    }else if ((c & 0x20) == 0) {
                        pos--;
                        n++;
                        break;
                    }else if ((c & 0x10) == 0) {
                        pos--;
                        n++;
                        break;
                    }else if ((c & 0x08) == 0) {
                        pos--;
                        n++;
                        break;
                    }else if ((c & 0x04) == 0) {
                        pos--;
                        n++;
                        break;
                    }else if ((c & 0x02) == 0) {
                        pos--;
                        n++;
                        break;
                    }
                }
                
                if (n > 0) {
                    [fh seekToFileOffset:offset - n];
                }
            }else {
                pos = data.length - 1;
            }
            
            NSData *d = [data subdataWithRange:NSMakeRange(0, pos + 1)];
            //200k text
            NSString *text = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            NSInteger textOffset = 0;
            
            while (textOffset < text.length) {
                if (is) {
                    is = false;
                }else {
                    [_array addObject:[NSNumber numberWithInteger:byteOffset]];
                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nil, nil];
                NSInteger len = 1287;
                if (textOffset + len >= text.length) {
                    len = text.length - textOffset;
                }
                NSString *s = [text substringWithRange:NSMakeRange(textOffset, len)];
                NSAttributedString *attr = [[NSAttributedString alloc] initWithString:s attributes:dict];
                
                //frame
                CGContextRef context = UIGraphicsGetCurrentContext();
                CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
                CGMutablePathRef path = CGPathCreateMutable();
                CGRect bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                CGPathAddRect(path, NULL, bounds);
                CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
                CFRange range = CTFrameGetVisibleStringRange(frame);
                
                //
                textOffset += range.length;
                NSRange rangetmp = NSMakeRange(range.location, range.length);
                NSInteger bytecount = [[s substringWithRange:rangetmp] dataUsingEncoding:NSUTF8StringEncoding].length;
                byteOffset += bytecount;
                
                
                CFRelease(path);
                CFRelease(frame);
                CFRelease(framesetter);
            }
            // 200k text end
        }
        
        NSLog(@"%@", _array.description);
        [fh seekToFileOffset:0];
        NSData *data = [fh readDataOfLength:bytecount*10];

        for (int i = 0; i < _array.count; i++) {

            NSInteger loc = ((NSNumber *)_array[i]).integerValue;
            NSInteger len;
            if (i == _array.count - 1) {
                len = data.length - loc;
            }else {
                len = ((NSNumber *)_array[i+1]).integerValue - loc;
            }
            
            NSData *d = [data subdataWithRange:NSMakeRange(loc, len)];
            NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            NSLog(@"%@", [str substringWithRange:NSMakeRange(0, 19)]);
            NSLog(@"......%d", i);
        }
        
    }
    return self;
}

@end
