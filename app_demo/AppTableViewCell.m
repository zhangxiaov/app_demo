//
//  AppTableViewCell.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/15.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppTableViewCell.h"
#import "UIImage+UIColor.h"
#import "AppConfig.h"


static const NSString *identifier = @"bookcell";

@interface AppTableViewCell ()
//@property (nonatomic, copy) NSString *background;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *info;
//@property (nonatomic, copy) NSString *progress;
@end

@implementation AppTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bookBackgroundImage = [[UIImageView alloc] init];
        _bookBackgroundImage.frame = CGRectMake(10, 5, 60, 50);
        _bookBackgroundImage.image = [UIImage imageWithColor:[UIColor grayColor]];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(80, 0, SCREEN_WIDTH - 140, 30);
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(80, 30, SCREEN_WIDTH - 90, 30);
        _infoLabel.textColor = UIColorFromHex(0x959595);
        
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 40, 30);
        
        [self.contentView addSubview:_bookBackgroundImage];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_infoLabel];
        [self.contentView addSubview:_progressLabel];
    }
    
    return self;
}
//
//- (AppTableViewCell *)cellWithTableView:(UITableView *)tableView withBackground:(NSString *)background
//                                   name:(NSString *)name info:(NSString *)info progress:(NSString *)progress {
//    AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (cell == nil) {
//        cell = [[AppTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    return cell;
//}

@end
