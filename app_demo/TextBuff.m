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
        
        NSInteger bytecount = 1000000;
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:@"filepath"];
        NSInteger len = [fh seekToEndOfFile];
        NSInteger byteOffset = 0;
        
        while ([fh offsetInFile] < len) {
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
            }
            
            //200k text
            NSString *text = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, pos)] encoding:NSUTF8StringEncoding];
            NSInteger textOffset = 0;
            
            while (textOffset < text.length) {
                [_array addObject:[NSNumber numberWithInteger:byteOffset]];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nil, nil];
                NSAttributedString *attr = [[NSAttributedString alloc] initWithString:text attributes:dict];
                
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
                NSInteger bytecount = [[text substringWithRange:rangetmp] dataUsingEncoding:NSUTF8StringEncoding].length;
                byteOffset += byteOffset;
                
                CFRelease(path);
                CFRelease(frame);
                CFRelease(framesetter);
            }// 200k text end
        }
        

        
        
    }
    return self;
}



@end
