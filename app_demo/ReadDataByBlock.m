//
//  ReadFileByBlock.m
//  app_demo
//
//  Created by 张新伟 on 15/10/8.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "ReadDataByBlock.h"
#import "AppConfig.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface ReadDataByBlock ()
@property (nonatomic, assign) int dataPosition;
@property (nonatomic, assign) int from;
@property (nonatomic, assign) int to;
@property (nonatomic, assign) NSData *data;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation ReadDataByBlock

- (instancetype)initWithTitle:(NSString *)title {
    
    if (_filePath == nil) {
        NSString *str = [title stringByAppendingPathExtension:@"txt"];
        _filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] stringByAppendingString:str];
    }
    
    if (byteLenForZh == 0) {
        int lineCharsCount = floor(CONTENT_WIDTH / FONT_SIZE_CONTENT);
        int linesCount = floor(CONTENT_HEIGHT / FONT_SIZE_CONTENT);
        
        byteLenForZh = 3*lineCharsCount*linesCount;
    }
    
    return self;
}

- (NSString *)updateFrame {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    _data = [handle readDataOfLength:byteLenForZh];
    NSString *s = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light",FONT_SIZE_CONTENT, NULL);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                          (id)CFBridgingRelease(fontRef), kCTFontAttributeName,
                          (id) [UIColor whiteColor].CGColor, (NSString *) kCTStrokeColorAttributeName,
                          (id)[NSNumber numberWithFloat: 0.0], (NSString *)kCTStrokeWidthAttributeName,
                          nil];
    
    NSString *content = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:content attributes:dict];

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(NORMAL_PADDING, 20, CONTENT_WIDTH, CONTENT_HEIGHT);
    CGRect textFrame = CGRectInset(rect, NORMAL_PADDING, 20);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    return [content substringToIndex:range.length];
    
//    return [content ];
//    textPos += range.length;
//    NSValue *value = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
//    [self.ranges addObject:value];
//    
//    
////    CFRelease(fontRef);
//    CFRelease(framesetter);
//    CFRelease(frame);
//    CFRelease(path);
//    ++totalPages;
}

- (NSRange)DataCanVisibleForUTF8:(NSData *)data {
    unsigned long s = 0;
    unsigned long end = data.length - 1;
    
    char c = '\0';
    while (s < end) {
        [data getBytes:&c range:NSMakeRange(s, sizeof(c))];
        if ((c & 0x40) == 0) {
            ++ s;
        }else {
            break;
        }
    }
    
    while (end > 0) {
        [data getBytes:&c range:NSMakeRange(end, sizeof(c))];
        if ((c & 0x40) == 0) {
            -- end;
        }else {
            break;
        }
    }
    
    return NSMakeRange(s, end);
}


@end
