//
//  EmojiViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/4.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "EmojiViewController.h"

@interface EmojiViewController () <UITextViewDelegate>

@end

@implementation EmojiViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 100, 200)];
        text.delegate = self;
        [text becomeFirstResponder];
        text.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:text];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *input = textView.text;
    NSLog(@"%d", [self check:input]);
}

- (bool)check:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
