//
//  CommentTextView.m
//  app_demo
//
//  Created by zhangxinwei on 15/11/30.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "CommentTextView.h"
#import "UIImage+UIColor.h"
#import "AppConfig.h"

@interface CommentTextView () <UIImagePickerControllerDelegate>

@end

@implementation CommentTextView

- (instancetype)init
{
    // h = h-(216 +100)
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 396, [UIScreen mainScreen].bounds.size.width, 396)];
    if (self) {
        
        self.backgroundColor = UIColorFromHex(0xf1f1f1);
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 80)];
        [_textView becomeFirstResponder];
        

        UIButton *button_photo = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 40, 30)];
        button_photo.titleLabel.font = [UIFont systemFontOfSize:13];
        [button_photo setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [button_photo setTitle:@"拍照" forState:UIControlStateNormal];
        [button_photo addTarget:self action:@selector(doPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button_img = [[UIButton alloc] initWithFrame:CGRectMake(60, 100, 40, 30)];
        button_img.titleLabel.font = [UIFont systemFontOfSize:13];
        [button_img setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [button_img setTitle:@"图片" forState:UIControlStateNormal];
        [button_img addTarget:self action:@selector(doImg) forControlEvents:UIControlEventTouchUpInside];

        UIButton *button_v = [[UIButton alloc] initWithFrame:CGRectMake(110, 100, 40, 30)];
        button_v.titleLabel.font = [UIFont systemFontOfSize:14];
        [button_v setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [button_v setTitle:@"语音" forState:UIControlStateNormal];
        [button_v addTarget:self action:@selector(doV) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 40 -10;
        UIButton *button_send = [[UIButton alloc] initWithFrame:CGRectMake(x, 100, 40, 30)];
        button_send.titleLabel.font = [UIFont systemFontOfSize:13];
        [button_send setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [button_send setTitle:@"发布" forState:UIControlStateNormal];
        [button_send addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_textView];
        [self addSubview:button_photo];
        [self addSubview:button_img];
        [self addSubview:button_v];
        [self addSubview:button_send];

    }
    return self;
}

#pragma event

- (void)doPhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:@"该设备不支持拍照功能!"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        if ([self superview]) {
            
            self.alpha = 0;
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
//            [self.fromViewController presentViewController:controller animated:YES completion:nil];
            [self.fromViewController presentViewController:controller animated:YES completion:^{
//                self.alpha = 1.0;
                
            }];
        }
    }
}

- (void)doImg {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:@"该设备无法查看图片!"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
    }
}

- (void)doV {
    
}

- (void)doSend {
    if (self.bridgeBlock) {
        [self removeFromSuperview];
        self.bridgeBlock();
    }
}

+ (CommentTextView *)share {
    static CommentTextView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CommentTextView alloc] init];
    });
    
    [instance.textView becomeFirstResponder];
    return instance;
}



@end
