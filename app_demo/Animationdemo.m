//
//  Animationdemo.m
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "Animationdemo.h"

@implementation Animationdemo

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    
    [self showDialogView:self];
    
    [NSThread sleepForTimeInterval:10];
    
    [self closeDialogView:self];
    
    return self;
}

-(void) showDialogView:(UIView *) view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:3];
    CGRect rect = [view frame];
    
    rect.origin.x = 0;
    rect.origin.y = 20;
    [view setFrame:rect];
    [UIView commitAnimations];
}

-(void) closeDialogView:(UIView *) view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [view frame];
    
    rect.origin.x = 0;
    rect.origin.y = 460;
    [view setFrame:rect];
    [UIView commitAnimations];
}

@end
