//
//  Regx.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/21.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "Regx.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@implementation Regx

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (NSAttributedString *)test {
    //组装一个字符串，需要把里面的网址解析出来
    
//    NSString *urlString=@"<font size=20>1212sfdsfhttp://www.baidu.com3543434343<font size=30>fafafafa1 <a href=ID:100>fafafafa2</a>fafafafaf3<img src=d.png width=100 height=50/>";
    
      NSString *urlString=@"<font size=20>1212sfdsfhttp://www.baidu.com3543434343<img src=d.png width=100 height=50/>afafafafafafa<test >fafaf";
    
    NSMutableString *text = [[NSMutableString alloc] init];
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    
    NSError *error;
    //http+:[^\\s]* 这个表达式是检测一个网址的。
    
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<.+?>" options:0 error:&error];
    
    if (regex != nil) {
//        int l = [urlString length];
//        int loc = 0;
//        while (loc < l) {
//            NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(loc, [urlString length])];
//            if (firstMatch) {
//                NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
//                NSString *result=[urlString substringWithRange:resultRange];
//                NSLog(@"%@, %d",result, resultRange.location);
//                NSString *t = [urlString substringWithRange:NSMakeRange(loc, resultRange.location)];
//                [str appendString:t];
//                loc = resultRange.location + resultRange.length;
//            }
//        }
        
        NSArray *a = [regex matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        NSMutableArray *ma = [[NSMutableArray alloc] init];
        int loc = 0;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];

        for (int i = 0; i < a.count; i ++) {
            NSTextCheckingResult *r = [a objectAtIndex:i];
            if (r) {
                NSRange range = [r range];
                NSLog(@"range = %d, %d, %@", range.location, range.length, [urlString substringWithRange:range]);
            }
        }

        NSMutableDictionary *d2;
        for (int i = 0; i < a.count; i ++) {
            NSTextCheckingResult *r = [a objectAtIndex:i];
            if (r) {
                NSRange range = r.range;
                int loc = range.location + range.length ;
                int len = 0;
                
                if (i+1 >= a.count) {
                     len = [urlString length] - range.location - range.length;
                }else {
                    NSTextCheckingResult *r2 = [a objectAtIndex:i+1];
                    len = r2.range.location - range.location - range.length;
                }

                NSString *t = [urlString substringWithRange:NSMakeRange(loc, len)];
                NSString *result = [urlString substringWithRange:range];
                if ([result hasPrefix:@"<font "]) {
                    if ([result containsString:@"size"]) {
//                        NSString *s2 = [result ];
                    }
                    CTFontRef font = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light", 30.0f, NULL);
                     d2= [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)[UIColor redColor].CGColor, kCTForegroundColorAttributeName,
                                        (__bridge id)font, kCTFontAttributeName, nil];
                    NSAttributedString *a = [[NSAttributedString alloc] initWithString:t attributes:d2];
                    [att appendAttributedString:a];
                }else if ([result hasPrefix:@"<a "]) {
                    CTFontRef font = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light", 10.0f, NULL);
                     d2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)[UIColor greenColor].CGColor, kCTForegroundColorAttributeName,
                                        (__bridge id)font, kCTFontAttributeName,
                                        (id)[NSNumber numberWithInt:kCTUnderlineStyleDouble], kCTUnderlineStyleAttributeName, nil];
                    NSAttributedString *a = [[NSAttributedString alloc] initWithString:t attributes:d2];
                    [att appendAttributedString:a];
                }else if ([result hasPrefix:@"<img "]) {
                    [d2 setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
                    NSAttributedString *a = [[NSAttributedString alloc] initWithString:t attributes:d2];
                    [att appendAttributedString:a];
                }else if ([result hasPrefix:@"<test "]) {
                    [d2 setObject:(id)[UIColor greenColor].CGColor forKey:(__bridge NSString *)kCTForegroundColorAttributeName];
                    NSAttributedString *a = [[NSAttributedString alloc] initWithString:t attributes:d2];
                    [att appendAttributedString:a];
                }
            }
        }
        
        if (loc < [urlString length]) {
            [text appendString:[urlString substringWithRange:NSMakeRange(loc, [urlString length] - loc)]];
        }
        
        NSLog(@"range = %@", [urlString substringWithRange:NSMakeRange(loc,[urlString length] - loc)]);
        
        NSRange r2 = NSMakeRange(loc, [urlString length] - loc);
        NSValue *value = [[NSValue alloc] initWithBytes:&r2 objCType:@encode(NSRange)];
        [ma addObject:value];
        NSLog(@"%@, %d, %d", text, loc, [urlString length]);
        NSLog(@"%p", ma);
        NSLog(@"%@", att);
        
        
        return att;
    }
    
    return nil;
}

- (void)backup {
    
}

////
////  DemoLabel.m
////  app_demo
////
////  Created by zhangxinwei on 15/10/15.
////  Copyright (c) 2015年 张新伟. All rights reserved.
////
//
//#import "DemoLabel.h"
//#import <CoreText/CoreText.h>
//#import "Regx.h"
//
//static inline double radians (double degrees) {return degrees * M_PI/180;}
//@interface DemoLabel ()
//@property (nonatomic, strong) NSArray *array;
//@end
//
//@implementation DemoLabel
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _text = @"发放拉开合法身份了fkdjfdkfhekjb发送<img src=MISAskAddFile@2x.png width=300 height=40 />的反馈撒返回尽快释放发到空间发电机发电撒风k看到积分卡发卡量发空间发";
//    }
//
////    UIImage *img = [self imageWithColor:[UIColor grayColor]];
////    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MISAskAddFile"]];
////    v.frame = CGRectMake(0, 0, 30, 30);
//
////    UIImageView *v2 = [[UIImageView alloc] initWithImage:[self rotatedImageWith:[UIImage imageNamed:@"MISAskAddFile"] degrees:90]];
//////    v2.frame = CGRectMake(50, 50, 30, 30);
////    v2.backgroundColor = [UIColor yellowColor];
////
////    [self addSubview:v2];
//////    [self addSubview:v];
//
//    return self;
//}
//
//- (void)test {
//
//    // 图纸
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    //===== cgcontextfillrect fill color
////    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
////    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
//
//
//    // ====== kcgpathfill : fill color
////    CGContextAddRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
////    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//////    CGContextDrawPath(context, kCGPathEOFill);
////    CGContextFillPath(context);
//
//
//    //===== line
//    //===== kcgpathfillstroke : fill color and stroke
////    CGContextMoveToPoint(context, 0, 0);
////    CGContextAddLineToPoint(context, 300, 300);
////    CGContextAddLineToPoint(context, 59, 100);
////    CGContextMoveToPoint(context, 0, 0);
////    CGContextAddLineToPoint(context, 40, 400);
////    CGContextSetLineWidth(context, 5.0);
//////    CGContextDrawPath(context, kCGPathFillStroke);
////    CGContextStrokePath(context);
//
//    //===== line CGContextSetLineCap
////    CGContextMoveToPoint(context, 10, 10);
////    CGContextAddLineToPoint(context, 300, 300);
////    CGContextAddLineToPoint(context, 59, 100);
////    CGContextMoveToPoint(context, 0, 0);
////    CGContextAddLineToPoint(context, 40, 400);
////    CGContextSetLineWidth(context, 5.0);
////    CGContextSetLineCap(context, kCGLineCapSquare);
////    CGContextDrawPath(context, kCGPathFillStroke);
//
//    //===== CGContextSetLineDash
////    CGContextMoveToPoint(context, 10, 10);
////    CGContextAddLineToPoint(context, 300, 300);
////    CGContextAddLineToPoint(context, 59, 100);
////    CGContextMoveToPoint(context, 0, 0);
////    CGContextAddLineToPoint(context, 40, 400);
////    CGContextSetLineWidth(context, 5.0);
////    float  lengths[] = {10,20};
////    CGContextSetLineDash(context, 0, lengths, 2);
////    CGContextDrawPath(context, kCGPathFillStroke);
//
//    //===== CGContextAddArc
//    // 100,100 圆心  20 randius
////    CGContextAddArc(context, 100, 100, 50, 0, M_PI, 1);
////    CGContextAddLineToPoint(context, 100, 100);
////    CGContextScaleCTM(context, 1.0, -1.0);
////    CGContextDrawPath(context, kCGPathStroke);
//
//    //===== CGContextAddArcToPoint
////    CGContextMoveToPoint(context, 100, 50);
////    CGContextAddLineToPoint(context, 200, 100);
////    CGContextAddLineToPoint(context, 100, 150);
////    CGContextMoveToPoint(context, 100, 50);
////    CGContextAddArcToPoint(context, 200, 100, 100, 150, 50);
////    CGContextDrawPath(context, kCGPathStroke);
//
//    //===== path
////    CGMutablePathRef path = CGPathCreateMutable();
////    CGPathMoveToPoint(path, NULL, 50, 50);
////    CGPathMoveToPoint(path, NULL, 100, 100);
////    CGPathAddLineToPoint(path, NULL, 50, 200);
////    CGPathAddRect(path, NULL, CGRectMake(50, 200, 50, 50));
////    CGContextAddPath(context, path);
////    CGContextDrawPath(context, kCGPathStroke);
//
//    // rotate img
//    UIImageView *v1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MISAskAddFile@2x"]];
////    v1.frame = CGRectMake(40, 40, v1.frame.size.width, v1.frame.size.height);
//
//    UIImageView *v2 = [[UIImageView alloc] init];
//    v2.frame = CGRectMake(0, 0, 200, 200);
////    v2.image = [self rotatedImageWith:[UIImage imageNamed:@"MISAskAddFile@2x"] degrees:90];
//    v2.image = [self translateImageWith:[UIImage imageNamed:@"MISAskAddFile"] x:50.0 y:50.0];
//
//
//    [self addSubview:v1];
//    [self addSubview:v2];
//    //=====
//}
//
//- (void)contentSetting {
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_text];
//    int textLen = attr.length;
//
//    //text alignment
//    CTTextAlignment alignment = kCTLeftTextAlignment;
//    CTParagraphStyleSetting alignmentStyle;
//    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
//    alignmentStyle.value = &alignment;
//    alignmentStyle.valueSize = sizeof(alignment);
//
//    CGFloat firstLineindent = 30.0f;
//    CTParagraphStyleSetting firstLineStyle;
//    firstLineStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
//    firstLineStyle.value = &firstLineindent;
//    firstLineStyle.valueSize = sizeof(firstLineindent);
//
//    CGFloat lineSpace = 30.0f;
//    CTParagraphStyleSetting lineSpaceStyle;
//    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
//    lineSpaceStyle.value = &lineSpace;
//    lineSpaceStyle.valueSize = sizeof(lineSpace);
//
//    CTParagraphStyleSetting setting[] = {alignmentStyle, firstLineStyle, lineSpaceStyle};
//    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, 3);
//
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:(__bridge id)paragraphStyle forKey:(id)kCTParagraphStyleAttributeName];
//    [attr addAttributes:dict range:NSMakeRange(0, textLen)];
//
//    CTFontRef font = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light", 30.0f, NULL);
//    NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:(id)[UIColor redColor].CGColor, kCTForegroundColorAttributeName,
//                        (__bridge id)font, kCTFontAttributeName, nil];
//    [attr addAttributes:d2 range:NSMakeRange(0, 1)];
//
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20));
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextSaveGState(context);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    CTFrameDraw(frame, context);
//
//    CGPathRelease(path);
//    CFRelease(framesetter);
//}
//
//- (UIImage *)rotatedImageWith:(UIImage *)image degrees:(CGFloat)degrees {
//    // calculate the size of the rotated view's containing box for our drawing space
//    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
////    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
////    rotatedViewBox.transform = t;
//    CGSize rotatedSize = rotatedViewBox.frame.size;
//
//    // Create the bitmap context
//    UIGraphicsBeginImageContext(rotatedSize);
//    CGContextRef bitmap = UIGraphicsGetCurrentContext();
//
//    // Move the origin to the middle of the image so we will rotate and scale around the center.
////    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
//
//    //   // Rotate the image context
////    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
//
//    // Now, draw the rotated/scaled image into the context
//
////    CGContextRotateCTM(bitmap, 10);
//
////    CGContextTranslateCTM(bitmap, 0, 10);
//    CGContextScaleCTM(bitmap, .5, .5);
//    CGContextRotateCTM(bitmap, radians ( 22.));
//    CGContextTranslateCTM(bitmap, 40, 20);
//
////    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
//    CGContextSetFillColorWithColor(bitmap, [UIColor grayColor].CGColor);
//    CGContextFillRect(bitmap, rotatedViewBox.frame);
//
//    translateCoordSystem(bitmap, image.size.height);
//    CGContextDrawImage(bitmap, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
//
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//void translateCoordSystem(CGContextRef context, CGFloat f) {
//    CGContextTranslateCTM(context, 0.0f, f);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//}
//
//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0, 0, 1, 1);
//    UIGraphicsBeginImageContext(rect.size);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return img;
//}
//
//#pragma mark inherit
//
//- (void)drawRect:(CGRect)rect {
////    [self contentSetting];
////    UIImage *image = [UIImage imageNamed:@"MISAskAddFile"];
//        [super drawRect:rect];
//
//
//    Regx *r = [[Regx alloc] init];
//        NSAttributedString *attriString = [r test];
//
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
//
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, rect);
//
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//        CFRelease(path);
//        CFRelease(framesetter);
//
//        CTFrameDraw(frame, ctx);
//        CFRelease(frame);
//}
//
//- (void)parse {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//
//    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Arial", 15.0, NULL);
//    UIColor *color = [UIColor greenColor];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:(id)color.CGColor,kCTForegroundColorAttributeName,
//                          (__bridge id)font, kCTFontAttributeName, nil];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:s];
//
////    attr addAttributes:<#(NSDictionary *)#> range:<#(NSRange)#>
//
//}
//
//
//
//#pragma mark nscoding
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//
//    return nil;
//}
//
//@end


@end
