//
//  ZUtil.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZUtil.h"
#import "AppConfig.h"
#import "ZDBManager.h"
#import "ZBookManager.h"
#import <CoreText/CoreText.h>

@implementation ZUtil

+ (CGFloat)heightForText:(NSString *)text attr:(NSDictionary *)dict {
    return [text boundingRectWithSize:CGSizeMake(CONTENT_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}

//据字长 取在字符串字节中的索引
+ (void)byteIndexForPages:(NSString*)bookID {
    NSString* document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [[document stringByAppendingPathComponent:bookID] stringByAppendingPathExtension:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray* array = [@[] mutableCopy];
    BOOL is = false;

    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:path];
    long len = content.length;
    [fh seekToFileOffset:0];
    NSInteger byteOffset = 0;
    
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    int fontSize = [[ZBookManager manager].fontSize intValue];
    while ([fh offsetInFile] < len) {
        if (byteOffset > 0) {
            is = true;
            byteOffset = ((NSNumber *)array[array.count - 1]).integerValue;
            [fh seekToFileOffset: byteOffset];
        }
        
        NSData *data = [fh readDataOfLength:z_bytePreRead];
        NSInteger offset = [fh offsetInFile];
        NSInteger pos = 0;
        //汉字否
        if (data.length == z_bytePreRead) {
            char c = '\0';
            NSInteger n = 0;
            pos = z_bytePreRead - 1;
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
        
        //完整字符串 的字节
        NSData *d = [data subdataWithRange:NSMakeRange(0, pos + 1)];
        //200k text
        NSString *text = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        long textLen = text.length;
        NSInteger textOffset = 0;
        
        
        //attr
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0;
        paragraphStyle.paragraphSpacing = 10.0;
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle,
                               NSForegroundColorAttributeName:[UIColor blackColor],
                               NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
        

        while (textOffset < textLen) {
            if (is) {
                is = false;
            }else {
                [array addObject:[NSNumber numberWithInteger:byteOffset]];
            }
            
            NSInteger len = 1500;
            if (textOffset + len >= text.length) {
                len = text.length - textOffset;
            }
            NSString *s = [text substringWithRange:NSMakeRange(textOffset, len)];
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:s attributes:dict];
            
            //frame
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect bounds = CGRectMake(0, 0, w,h);
            CGRect textFrame = CGRectInset(bounds, 10, 20);
            CGPathAddRect(path, NULL, textFrame);
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
    }
    
    NSString* field = [NSString stringWithFormat:@"book_byteIndexs_%d", fontSize];
    [[ZDBManager manager] updatefield:field val:[array componentsJoinedByString:@","] bookID:bookID];
    
    [fh closeFile];
}

//据字长 分页 存入db
+ (void)paging:(NSString *)bookID {
    NSString* document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [[document stringByAppendingPathComponent:bookID] stringByAppendingPathExtension:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    int size = [[ZBookManager manager].fontSize intValue];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    paragraphStyle.paragraphSpacing = 10.0;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:size], NSParagraphStyleAttributeName:paragraphStyle,
                           NSForegroundColorAttributeName:[UIColor blackColor],
                           NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
    
    CGFloat height = [ZUtil heightForText:content attr:dict];
    NSInteger pages = ceil(height); //计算pages
    
    [[ZDBManager manager] updatefield:@"book_pages" val:[NSString stringWithFormat:@"%ld", pages] bookID:bookID];//存 pages
    [[ZDBManager manager] updatefield:@"book_charCount" val:[NSString stringWithFormat:@"%ld", content.length] bookID:bookID]; //存 字数
    [ZUtil byteIndexForPages:bookID]; //存 字节索引
}

@end
