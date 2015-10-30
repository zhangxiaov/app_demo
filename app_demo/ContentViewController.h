//
//  ContentViewController.h
//  app_demo
//
//  Created by zhangxinwei on 15/10/30.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController {
    bool isTap;
    int textPos;
}
@property (nonatomic, strong) UIView *toolView;
@end
