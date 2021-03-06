//
//  TextBuff.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/26.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "Pagination.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "Dao.h"
#import "Book.h"

@interface Pagination ()
@property (nonatomic, assign) NSInteger bytecount;
@property (nonatomic, copy) NSString *filePath;
@end

@implementation Pagination

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
//        _title = title;

        _bytecount = 100000000;
        _filePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:title] stringByAppendingPathExtension:@"txt"];
        
        NSString *tmpstr = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
        bool ishaven = [tmpstr containsString:@"\r"];
        NSLog(@"%d", ishaven);
        tmpstr = [tmpstr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [tmpstr writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 5.0;
//        paragraphStyle.paragraphSpacing = 10.0;
//        
//        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,
//                            NSForegroundColorAttributeName:[UIColor blackColor],
//                               NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
//        
//        CGRect s = [tmpstr boundingRectWithSize:CGSizeMake(CONTENT_WIDTH, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        
//        NSLog(@"pages :%f", s.size.height / CONTENT_HEIGHT);
        
        Dao *dao = [[Dao alloc] init];
        _book = [dao selectBook:title bookId:0];
        if (_book.bookid == 0) {
            _book = [[Book alloc]initWithName:title author:@"test" profile:@"test"];
            [dao insertBook:_book];
        }
        
        NSArray *a = [dao selectPages:_book.bookid fontSize:15];
        if (a && a.count > 0) {
            _array = [[NSMutableArray alloc] initWithArray:a];
        }else {
            [self fillArray:NFONT15];
            [dao insertPages:_book.bookid fontSize:15 a:_array];
        }
    }
    
    return self;
}

- (void)fillArray:(CGFloat)nfont {
    BOOL is = false;
    NSInteger bytecount = _bytecount;
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    _len = [fh seekToEndOfFile];
    [fh seekToFileOffset:0];
    NSInteger byteOffset = 0;
    
    NSTimeInterval t0 = [[NSDate date] timeIntervalSinceNow];
    while ([fh offsetInFile] < _len) {
        
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
            
//            //创建文本,    行间距
//            CGFloat lineSpace=0.0;//间距数据
//            CTParagraphStyleSetting lineSpaceStyle;
//            lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
//            lineSpaceStyle.valueSize=sizeof(lineSpace);
//            lineSpaceStyle.value=&lineSpace;
//            
//            //设置  段落间距
//            CGFloat paragraph = 10.0;
//            CTParagraphStyleSetting paragraphStyle;
//            paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
//            paragraphStyle.valueSize = sizeof(CGFloat);
//            paragraphStyle.value = &paragraph;
//            //创建样式数组
//            CTParagraphStyleSetting settings[]={
//                lineSpaceStyle,paragraphStyle
//            };
//            
//            //设置样式
//            CTParagraphStyleRef paragraphStyle1 = CTParagraphStyleCreate(settings, sizeof(settings));
//            CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT",nfont, NULL);
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
//                                  (__bridge id)fontRef, kCTFontAttributeName,
//                                  (id) [UIColor whiteColor].CGColor, (NSString *) kCTStrokeColorAttributeName,
//                                  (id)[NSNumber numberWithFloat: 0.0f], (NSString *)kCTStrokeWidthAttributeName,
//                                  (__bridge id)paragraphStyle1, (NSString *)kCTParagraphStyleAttributeName,
//                                  nil];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5.0;
            paragraphStyle.paragraphSpacing = 10.0;
            
            NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,
                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                   NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
            
            
            NSInteger len = 1500;
            if (textOffset + len >= text.length) {
                len = text.length - textOffset;
            }
            NSString *s = [text substringWithRange:NSMakeRange(textOffset, len)];
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:s attributes:dict];
            
            //frame
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            CGRect textFrame = CGRectInset(bounds, 10, 20);
            CGPathAddRect(path, NULL, textFrame);
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CFRange range = CTFrameGetVisibleStringRange(frame);
            
            //
            textOffset += range.length;
            NSRange rangetmp = NSMakeRange(range.location, range.length);
            NSInteger bytecount = [[s substringWithRange:rangetmp] dataUsingEncoding:NSUTF8StringEncoding].length;
            byteOffset += bytecount;
            
//            CFRelease(fontRef);
            CFRelease(path);
            CFRelease(frame);
            CFRelease(framesetter);
        }
        // 200k text end
    }
    
    NSLog(@"test time %f", [[NSDate date] timeIntervalSinceNow] - t0);
    NSLog(@"test array %@", [_array componentsJoinedByString:@","]);
    [fh closeFile];

    //2
//    NSTimeInterval s = [[NSDate date] timeIntervalSinceNow] ;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5.0;
//    paragraphStyle.paragraphSpacing = 10.0;
//    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,
//                           NSForegroundColorAttributeName:[UIColor blackColor],
//                           NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
//    
//    
//    int count = 100;
//    
//    
//    NSLog(@"test time %f", [[NSDate date] timeIntervalSinceNow] - s);

}

- (NSString *)strAtPos:(NSInteger)pos {
    NSInteger loc = ((NSNumber *)_array[pos]).integerValue;
    NSInteger len;
    if (pos == _array.count - 1) {
        len = _len - loc;
    }else {
        len = ((NSNumber *)_array[pos+1]).integerValue - loc;
    }
    
    NSString *filePath = [[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:_book.bookname] stringByAppendingPathExtension:@"txt"];
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [fh seekToFileOffset:loc];
    NSData *d = [fh readDataOfLength:len];
    NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    [fh closeFile];
    
    return str;
}

@end
