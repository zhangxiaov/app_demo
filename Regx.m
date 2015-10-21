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


@end
