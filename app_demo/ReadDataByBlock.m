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
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ReadDataByBlock

- (instancetype)initWithTitle:(NSString *)title {
    
    if (_filePath == nil) {
        _curPage = 1;
        _posArray = [[NSMutableArray alloc] initWithObjects:[[NSNumber alloc] initWithLong:0], nil];
        _array = [[NSMutableArray alloc] init];
        
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

- (NSString *)strForPage:(int)page isReverse:(BOOL)isReverse {
    if (_posArray.count > page + 1 && _posArray.count != 1) {
        long location = ((NSNumber *)_posArray[page]).longValue;
        long e = 0;
        if (_posArray.count < page + 1) {
            e = _dataLen;
        }else {
            e = ((NSNumber *)_posArray[page+1]).longValue;
        }
        
        long len = e - location;
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        [handle seekToFileOffset:location];
        NSData *data = [handle readDataOfLength:len];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        return str;
    }else if (isReverse == NO) {
        if (_dataPosition == _dataLen) {
            return nil;
        }
        
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        [handle seekToFileOffset:_dataPosition];
        NSString *content = [self strByDataForUTF8:[handle readDataOfLength:_oneLabelBytes]];
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
        NSNumber *n2 = [[NSNumber alloc] initWithLong:visibleStrBytesLen];
        [_array addObject:n2];
        _dataPosition += visibleStrBytesLen; // next char startpoint
        
        if (_dataPosition >= _dataLen) {
            _dataPosition = _dataLen;
        }
        
        NSLog(@"pos = %lld", _dataPosition);
        
        CFRelease(framesetter);
        CFRelease(frame);
        CFRelease(path);
        
        NSNumber *n = [[NSNumber alloc] initWithLong:_dataPosition];
        [_posArray addObject:n];
        
        return [content substringToIndex:range.length];
    }
    
    return nil;
}

- (void)test {
    
    __block long total = 0;
    [_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        total += ((NSNumber *)obj).longValue;
    }];
    NSLog(@"%ld", total);
}

- (NSString *)strByDataForUTF8:(NSData *)data{
    
    if (data.length == 0) {
        return nil;
    }
    
    unsigned long s = 0;
    unsigned long end = data.length - 1;
    NSString *str;
    
    char c = '\0';
    while (s < end) {
        [data getBytes:&c range:NSMakeRange(s, sizeof(c))];
//        if ((c & 0x40) == 0) {
        if ((c & 0x40) == 0 && (c & 0x80) != 0) {
            ++ s;
        }else {
            break;
        }
    }
    
    if (_dataPosition + data.length == _dataLen) {
        NSLog(@"end");
    }else {
        while (end > 0) {
            [data getBytes:&c range:NSMakeRange(end, sizeof(c))];
//            if ((c & 0x40) == 0) {
            if ((c & 0x40) == 0 && (c & 0x80) != 0) {
                -- end;
            }else {
                break;
            }
        }
    }
    
    NSRange range = NSMakeRange(s, end - s);
    NSLog(@"loc = %d, len = %d", s, end - s);
    str = [[NSString alloc] initWithData:[data subdataWithRange:range] encoding:NSUTF8StringEncoding];
    return str;
}

@end
