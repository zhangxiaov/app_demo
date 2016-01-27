//
//  ZLabel.h
//  app_demo
//
//  Created by 张新伟 on 16/1/27.
//  Copyright © 2016年 张新伟. All rights reserved.
//

@interface ZLabel : UIView
@property (nonatomic, copy) NSString* text;

@property (nonatomic, strong) NSMutableAttributedString *mAttr;

@property(nonatomic,assign)CGFloat line; //行间距
@property(nonatomic,assign)CGFloat paragraph;//段落间距
@property (nonatomic, copy) NSString *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) NSMutableArray *linkValue;
@property (nonatomic, strong) NSMutableArray *imageRects;
@property (nonatomic, strong) NSMutableArray *linkRects;
@end
