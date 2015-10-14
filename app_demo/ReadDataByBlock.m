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
        
        // rm \r
        
//        NSString *dpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString *path = [dpath stringByAppendingPathComponent:@"test.txt"];
//        
//        NSFileManager *fm = [NSFileManager defaultManager];
//        
//        
//        NSString *con = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
//        con = [con stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        
//        if (![fm fileExistsAtPath:path]) {
//            [fm createFileAtPath:path contents:[con dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//        }
//        
//
//        
//
//        NSFileHandle *h = [NSFileHandle fileHandleForWritingAtPath:_filePath];
//        [h seekToFileOffset:0];
//        
//        NSData *data = [con dataUsingEncoding:NSUTF8StringEncoding];
//        [h writeData:data];
//        [h closeFile];
//        
//        BOOL b = [con writeToFile:[_filePath stringByAppendingString:@".txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
//        if (b) {
//            NSLog(@"write success ");
//        }
//        
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        _dataLen = [handle seekToEndOfFile];
        
        int lineCharsCount = floor(CONTENT_WIDTH / FONT_SIZE_CONTENT);
        int linesCount = floor(CONTENT_HEIGHT / FONT_SIZE_CONTENT);
        _oneLabelBytes = 4*lineCharsCount*linesCount;
        
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
        long e = ((NSNumber *)_posArray[page+1]).longValue;
        
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
        
        NSData *d2 = [handle readDataOfLength:_oneLabelBytes];
        NSString *content = [self strByDataForUTF8:d2];
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
        
        if (_dataPosition == 14264) {
            NSLog(@"fsfs");
        }
        
//        if (_dataPosition >= _dataLen - 1) {
//            _dataPosition = _dataLen;
//        }
        
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
        if ((c & 0x40) == 0) {
            ++ s;
        }else {
            break;
        }
    }
    
    if (_dataPosition + data.length == _dataLen) {
        ;
    }else {
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
    }
    
    NSRange range = NSMakeRange(s, end - s + 1);
    NSData * d = [data subdataWithRange:range];
    str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    return str;
}

@end
