//
//  DemoLabel.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/15.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "DemoLabel.h"
#import "UIImage+UIColor.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation DemoLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _text = @"发放拉开合法身份了fkdjfdkfhekjb发送<img src=MISAskAddFile@2x.png width=300 height=40 />的反馈撒返回尽快释放发到空间发电机发电撒风k看到积分卡发卡量发空间发";
    }
    
    return self;
}

- (void)test {
    
    // 图纸
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //===== cgcontextfillrect fill color
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));

    
    // ====== kcgpathfill : fill color
//    CGContextAddRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
////    CGContextDrawPath(context, kCGPathEOFill);
//    CGContextFillPath(context);
    
    
    //===== line
    //===== kcgpathfillstroke : fill color and stroke
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 300, 300);
//    CGContextAddLineToPoint(context, 59, 100);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 40, 400);
//    CGContextSetLineWidth(context, 5.0);
////    CGContextDrawPath(context, kCGPathFillStroke);
//    CGContextStrokePath(context);
    
    //===== line CGContextSetLineCap
//    CGContextMoveToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 300, 300);
//    CGContextAddLineToPoint(context, 59, 100);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 40, 400);
//    CGContextSetLineWidth(context, 5.0);
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    //===== CGContextSetLineDash
//    CGContextMoveToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 300, 300);
//    CGContextAddLineToPoint(context, 59, 100);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 40, 400);
//    CGContextSetLineWidth(context, 5.0);
//    float  lengths[] = {10,20};
//    CGContextSetLineDash(context, 0, lengths, 2);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    //===== CGContextAddArc
    // 100,100 圆心  20 randius
//    CGContextAddArc(context, 100, 100, 50, 0, M_PI, 1);
//    CGContextAddLineToPoint(context, 100, 100);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextDrawPath(context, kCGPathStroke);
    
    //===== CGContextAddArcToPoint
//    CGContextMoveToPoint(context, 100, 50);
//    CGContextAddLineToPoint(context, 200, 100);
//    CGContextAddLineToPoint(context, 100, 150);
//    CGContextMoveToPoint(context, 100, 50);
//    CGContextAddArcToPoint(context, 200, 100, 100, 150, 50);
//    CGContextDrawPath(context, kCGPathStroke);
    
    //===== path
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 50, 50);
//    CGPathMoveToPoint(path, NULL, 100, 100);
//    CGPathAddLineToPoint(path, NULL, 50, 200);
//    CGPathAddRect(path, NULL, CGRectMake(50, 200, 50, 50));
//    CGContextAddPath(context, path);
//    CGContextDrawPath(context, kCGPathStroke);
    
    // rotate img
    UIImageView *v1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MISAskAddFile@2x"]];
//    v1.frame = CGRectMake(40, 40, v1.frame.size.width, v1.frame.size.height);
    
    UIImageView *v2 = [[UIImageView alloc] init];
    v2.frame = CGRectMake(0, 0, 200, 200);
//    v2.image = [self rotatedImageWith:[UIImage imageNamed:@"MISAskAddFile@2x"] degrees:90];
    v2.image = [self translateImageWith:[UIImage imageNamed:@"MISAskAddFile"] x:50.0 y:50.0];

    
    [self addSubview:v1];
    [self addSubview:v2];
    //===== 
}

- (void)contentSetting {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_text];
    int textLen = attr.length;
    
    //text alignment
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.value = &alignment;
    alignmentStyle.valueSize = sizeof(alignment);
    
    CGFloat firstLineindent = 30.0f;
    CTParagraphStyleSetting firstLineStyle;
    firstLineStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    firstLineStyle.value = &firstLineindent;
    firstLineStyle.valueSize = sizeof(firstLineindent);
    
    CGFloat lineSpace = 30.0f;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.value = &lineSpace;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    
    CTParagraphStyleSetting setting[] = {alignmentStyle, firstLineStyle, lineSpaceStyle};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, 3);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:(__bridge id)paragraphStyle forKey:(id)kCTParagraphStyleAttributeName];
    [attr addAttributes:dict range:NSMakeRange(0, textLen)];
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light", 30.0f, NULL);
    NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:(id)[UIColor redColor].CGColor, kCTForegroundColorAttributeName,
                        (__bridge id)font, kCTFontAttributeName, nil];
    [attr addAttributes:d2 range:NSMakeRange(0, 1)];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(frame, context);
    
    CGPathRelease(path);
    CFRelease(framesetter);
}

- (UIImage *)rotatedImageWith:(UIImage *)image degrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)translateImageWith:(UIImage *)image x:(CGFloat)x y:(CGFloat)y {
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 300)];
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    
    //this gets the graphic context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //you can stroke and/or fill
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    [circle fill];
    [circle stroke];
    
    //now get the image from the context
    UIImage *bezierImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return bezierImage;
}

#pragma mark inherit

- (void)drawRect:(CGRect)rect {
//    [self contentSetting];
    [self test];
}

#pragma mark nscoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return nil;
}

@end
