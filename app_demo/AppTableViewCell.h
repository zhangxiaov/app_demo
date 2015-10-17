//
//  AppTableViewCell.h
//  app_demo
//
//  Created by zhangxinwei on 15/10/15.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bookBackgroundImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@end
