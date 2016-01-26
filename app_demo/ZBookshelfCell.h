//
//  ZBookshelfCell.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBookshelfCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* bookIconView;
@property (nonatomic, strong) UILabel* bookNameLabel;

+ (NSString*)reuseIdentifier;
- (void)fillData:(id)obj;
@end
