//
//  ZMessageCell.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMessageModel;
@interface ZMessageCell : UITableViewCell

- (void)updateWithMessage:(ZMessageModel*)message;
+ (NSString*)reuseIdentifier;

@end
