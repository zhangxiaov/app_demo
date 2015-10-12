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
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation ReadDataByBlock

- (instancetype)initWithTitle:(NSString *)title {
    
    if (_filePath == nil) {
        
        _curPage = 1;
        
        NSString *str = [title stringByAppendingPathExtension:@"txt"];
        
        _filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] stringByAppendingString:str];
        
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        _dataLen = [handle seekToEndOfFile];
        
        int lineCharsCount = floor(CONTENT_WIDTH / FONT_SIZE_CONTENT);
        int linesCount = floor(CONTENT_HEIGHT / FONT_SIZE_CONTENT);
        
        _oneLabelBytes = 3*lineCharsCount*linesCount;
        _dataPosition = 0;
        if (_oneLabelBytes > 0) {
            _possibleTotalPages =  (int)_dataLen / _oneLabelBytes;
        }
    }
    
    return self;
}

- (NSArray *)array {
    if (_array == nil) {
        _array = [[NSArray alloc] initWithObjects:@"", @"", @"", nil];
    }
    
    return _array;
}

- (NSDictionary *)dict {
    if (_dict == nil) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light",FONT_SIZE_CONTENT, NULL);
        _dict = [NSDictionary dictionaryWithObjectsAndKeys:
                 (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                 (id)CFBridgingRelease(fontRef), kCTFontAttributeName,
                 (id) [UIColor whiteColor].CGColor, (NSString *) kCTStrokeColorAttributeName,
                 (id)[NSNumber numberWithFloat: 0.0f], (NSString *)kCTStrokeWidthAttributeName,
                 nil];
    }
    
    return _dict;
}

- (NSString *)skip:(unsigned long long)p isReverse:(BOOL)isReverse {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    NSString *content;
    NSRange r;
    memset(&r, 0, sizeof(NSRange));
    
    if (isReverse) {
        unsigned long location = _dataPosition - p - _oneLabelBytes;
        [handle seekToFileOffset:location];
    }else {
        [handle seekToFileOffset:_dataPosition];
    }
    
    if (_dataPosition == 11350) {
        NSLog(@"");
    }
    
    if (_dataLen - _dataPosition < _oneLabelBytes) {
        NSData *d = [handle readDataOfLength:_dataLen - _dataPosition];

        if ((content = [[NSString alloc] initWithData:[handle readDataOfLength:_dataLen - _dataPosition] encoding:NSUTF8StringEncoding]) == nil) {
            
            unsigned long l = handle.offsetInFile;
            NSData *d = [handle readDataOfLength:_dataLen - _dataPosition];
            content = [ReadDataByBlock strByDataForUTF8:[handle readDataOfLength:_dataLen - _dataPosition] visibleRange:&r];
        }else {
            content = [[NSString alloc] initWithData:[handle readDataOfLength:_dataLen - _dataPosition] encoding:NSUTF8StringEncoding];
        }
    }else {
        content = [ReadDataByBlock strByDataForUTF8:[handle readDataOfLength:_oneLabelBytes] visibleRange:&r];
    }
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:content attributes:self.dict];

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(NORMAL_PADDING, 20, CONTENT_WIDTH, CONTENT_HEIGHT);
    CGRect textFrame = CGRectInset(rect, NORMAL_PADDING, 20);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    
    NSString *visibleStr = [content substringToIndex:range.length];
    unsigned long visibleStrBytesLen = [[visibleStr dataUsingEncoding:NSUTF8StringEncoding] length];
    _dataPosition += visibleStrBytesLen + 1; // next char startpoint
    
    NSLog(@"pos = %lld", _dataPosition);
    
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(path);
    
    return [content substringToIndex:range.length];
}

+ (NSString *)strByDataForUTF8:(NSData *)data visibleRange:(NSRange *)range {
    
    if (data.length == 0) {
        return nil;
    }
    
    unsigned long s = 0;
    unsigned long end = data.length - 1;
    NSString *str;
    
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
    
    range->location = s;
    range->length = end - s;

    str = [[NSString alloc] initWithData:[data subdataWithRange:*range] encoding:NSUTF8StringEncoding];
    
    return str;
}

@end
