//
//  DemoLabel.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/15.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "DemoLabel.h"
#import <CoreText/CoreText.h>

/* Callbacks */
static void deallocCallback( void* ref ){
//    [(__bridge id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}


static inline double radians (double degrees) {return degrees * M_PI/180;}
@interface DemoLabel ()

@end

@implementation DemoLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _text = @"<font color=red >发放拉开合法身份了fkdjfdkfhekjb发送<img src=MISAskAddFile@2x.png width=40 height=40 />的反馈撒返回尽快释放发到空间发电机发电撒风k看到积分卡发卡量发空间发";
        _font = @"Arial";
        _color = [UIColor blackColor];
        _strokeColor = [UIColor redColor];
        _strokeWidth = 5.0;
        _fontSize = 15.0;
        _images = [NSMutableArray array];

    }
    
    return self;
}

- (void)contentSetting {
  
}

#pragma mark inherit

- (void)drawRect:(CGRect)rect {
    
    
}

- (void)parse:(NSString *)originStr {
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] init];
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *matches = [regx matchesInString:originStr options:0 range:NSMakeRange(0, [originStr length])];
    
//    for (NSTextCheckingResult *result in matches) {
    for (int i = 0; i < matches.count; i ++) {
        NSTextCheckingResult *result = [matches objectAtIndex:i];
        NSArray *matches2 = [[originStr substringWithRange:result.range] componentsSeparatedByString:@"<"];
        CTFontRef font = CTFontCreateWithName((CFStringRef)self.font, self.fontSize, NULL);
        
        NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:(__bridge id)font, kCTFontAttributeName,
                           (id)self.color.CGColor , kCTForegroundColorAttributeName,
                           (id)self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                           (id)[NSNumber numberWithFloat:self.strokeWidth], kCTStrokeWidthAttributeName,nil];
        
        [mAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[matches2 objectAtIndex:0] attributes:d]];
        
        if ([matches2 count] > 1) {
            NSString *tag = (NSString *)[matches2 objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
                NSRegularExpression *rgex_color = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=)\\w+" options:0 error:nil];
                [rgex_color enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];
                
                NSRegularExpression *rgex_face = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=)\\w+" options:0 error:nil];
                [rgex_face enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.font = [tag substringWithRange:result.range];
                }];
                
                NSRegularExpression *rgex_fontsize = [[NSRegularExpression alloc] initWithPattern:@"(?<=fontSize=)\\w+" options:0 error:nil];
                [rgex_fontsize enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.fontSize = [tag substringWithRange:result.range].floatValue;
                }];

                NSRegularExpression *rgex_strokeColor = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=)\\w+" options:0 error:nil];
                [rgex_strokeColor enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                    self.strokeColor = [UIColor performSelector:colorSel];
                }];

                NSRegularExpression *rgex_strokeWidth = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeWidth=)\\w+" options:0 error:nil];
                [rgex_strokeWidth enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    self.strokeWidth = [tag substringWithRange:result.range].floatValue;
                }];
                
            }else if ([tag hasPrefix:@"img"]) {
                __block NSNumber* width = [NSNumber numberWithInt:0];
                __block NSNumber* height = [NSNumber numberWithInt:0];
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=)\\d+" options:0 error:NULL];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=)\\d+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                //image name
                NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=)[^\\s]+" options:0 error:NULL];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                // add imagename, width height location info
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, @"width",
                  height, @"height",
                  fileName, @"fileName",
                  [NSNumber numberWithInt: [mAttr length]], @"location",
                  nil]
                 ];

                //render space when drawing text
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys:width, @"width", height, @"height", nil];
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr)); //3
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];
                
                //add a space to the text so that it can call the delegate
                [mAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate]];

            }else if ([tag hasPrefix:@"a "]) {
                //href=1000
                __block NSString *val = @"";
                NSRegularExpression* regx = [[NSRegularExpression alloc] initWithPattern:@"(?<=href=)[^>|^\\s]+" options:0 error:NULL];
                [regx enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    val = [tag substringWithRange: match.range];
                }];
                [self.as addObject:[NSDictionary dictionaryWithObjectsAndKeys:val, @"href", [NSNumber numberWithInt:[mAttr length]], @"location", nil]];
            }else if ([tag hasPrefix:@"/a"]) {
                [self.ends addObject:[NSNumber numberWithInt:[mAttr length]]];
            }
        }
    }
    
}



#pragma mark nscoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return nil;
}

@end
