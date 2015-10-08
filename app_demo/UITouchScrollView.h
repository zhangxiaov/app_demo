//
//  UITouchScrollView.h
//  app_demo
//
//  Created by 张新伟 on 15/10/4.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol UIScrollViewTouchesDelegate
//-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)scrollView;
//@end


@interface UITouchScrollView : UIScrollView
//
//@property(nonatomic,assign) id<UIScrollViewTouchesDelegate> touchesdelegate;


@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, assign) NSTimeInterval touchTimer;

@end
