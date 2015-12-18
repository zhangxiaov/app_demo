//
//  CommentCell.h
//  app_demo
//
//  Created by zhangxinwei on 15/11/23.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
+ (NSString *)reuseIdentifier;
@end
