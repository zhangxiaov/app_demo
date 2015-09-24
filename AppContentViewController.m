//
//  AppContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppContentViewController.h"
#import "AppConfig.h"

@interface AppContentViewController () {
    int totalPages;
    int currentPage;
    NSString *content;
}
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AppContentViewController

- (void)viewDidLoad {
    
    isTap = YES;
    totalPages = 0;
    currentPage = 0;
    
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
    
    if (!content) {
        content = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = @{NSFontAttributeName : [UIFont fontWithName:@"Heiti SC" size:FONT_SIZE_MAX]};
        
        // 整个文本size
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        if (contentSize.height < SCREEN_HEIGHT - 40) {
            ((UILabel *)self.labels[0]).text = content;
        }else {
            NSUInteger contentLength = content.length;
            totalPages = contentSize.height / SCREEN_WIDTH - 40;
            
        }
    }
}

- (NSArray *)labels {
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 0; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Heiti SC" size:FONT_SIZE_MAX];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
        
        [a addObject:label];
        
        [self.scrollView addSubview:label];
    }
    
    return a;
}

- (NSData *)data {
    
    NSString *str = self.title;
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] stringByAppendingString:str];
    return [NSData dataWithContentsOfFile:path];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH*3, SCREEN_HEIGHT - 40)];
        _scrollView.backgroundColor = [UIColor grayColor];
    }
    
    return _scrollView;
}

#pragma mark

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isTap = !isTap;
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
}

@end
