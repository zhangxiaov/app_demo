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

@interface ReadDataByBlock () {
//    unsigned long long dataPosition;
//    unsigned long long dataLen;
//    int byteLenForZh;
//    int curPage;
//    int possibleTotalPages;
}
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
        
        _byteLenForZh = 3*lineCharsCount*linesCount;
        _dataPosition = 0;
        if (_byteLenForZh > 0) {
            _possibleTotalPages = _dataLen / _byteLenForZh;
        }
    }
    
    return self;
}

- (NSString *)dataAtPos:(unsigned long long)p isReverse:(BOOL)isReverse {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    
    if (isReverse) {
        _dataPosition = (_dataPosition - _byteLenForZh) > 0 ? (_dataPosition - _byteLenForZh) : 0;
        if (_dataPosition > 0) {
            _dataPosition = [self getStartPointOfTheCharactor:_dataPosition];
        }
        -- _curPage;
    }else {
        ++ _curPage;
    }

    //b8e4beaf e69886e5 90bee6b0 8fe4b8ba e4b9b1e3 8082e6b1 a4e4b983 e585b4e5 b888e78e
    
    [handle seekToFileOffset:_dataPosition];
    
    _data = [handle readDataOfLength:_byteLenForZh];
    
    _byteLenForZh = [self getStartPointOfTheCharactor:_byteLenForZh - 2];
    
//    NSString *s = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light",FONT_SIZE_CONTENT, NULL);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                          (id)CFBridgingRelease(fontRef), kCTFontAttributeName,
                          (id) [UIColor whiteColor].CGColor, (NSString *) kCTStrokeColorAttributeName,
                          (id)[NSNumber numberWithFloat: 0.0f], (NSString *)kCTStrokeWidthAttributeName,
                          nil];
    NSRange range1 = NSMakeRange(0, _byteLenForZh);
    NSString *content = [[NSString alloc] initWithData:[_data subdataWithRange:range1] encoding:NSUTF8StringEncoding];
//    content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:content attributes:dict];

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(NORMAL_PADDING, 20, CONTENT_WIDTH, CONTENT_HEIGHT);
    CGRect textFrame = CGRectInset(rect, NORMAL_PADDING, 20);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    
    NSString *visibleStr = [content substringToIndex:range.length];
    unsigned long visibleStrBytesLen = [[visibleStr dataUsingEncoding:NSUTF8StringEncoding] length];
//    pos += visibleStrBytesLen;
    _dataPosition += visibleStrBytesLen;
    
//    CFRelease(fontRef);
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(path);
    
    NSLog(@"test");
    
    return [content substringToIndex:range.length];
}

- (int) getStartPointOfTheCharactor:(int)position {
    int inner_pos = position;
    while (inner_pos > 0) {
        char c = '\0';
        [_data getBytes:&c range:NSMakeRange(inner_pos, sizeof(c))];
        if ((c & 0x40) == 0 && (c & 0x80) != 0) {
            --inner_pos;
        } else {
            return inner_pos;
        }
    }
    return inner_pos;
}


@end
