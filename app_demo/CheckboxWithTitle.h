//
//  CheckboxWithTitle.h
//  app_demo
//
//  Created by zhangxinwei on 15/10/29.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckboxWithTitle;
typedef void (^TouchButton) (CheckboxWithTitle *);

@interface CheckboxWithTitle : UIButton
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, copy) TouchButton block;
@property (nonatomic, assign) BOOL checked;
@end
