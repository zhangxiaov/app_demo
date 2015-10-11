//
//  AppContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppContentViewController.h"
#import "AppConfig.h"
#import "AppLabel.h"
#import <CoreText/CoreText.h>
#import "UITouchScrollView.h"
#import "SqlOP.h"
#import "ReadDataByBlock.h"

@interface AppContentViewController () <UIScrollViewDelegate>{
    int totalPages;
    int startPageOffsetx;
    int pageDragging;
    long len;
    BOOL dragging;
}
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *footerView;
@property (nonatomic, strong) UITouchScrollView *scrollView;
@property (nonatomic, strong) ReadDataByBlock *readData;
@end

@implementation AppContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _readData = [[ReadDataByBlock alloc] initWithTitle:self.title];
    
    totalPages = _readData.possibleTotalPages;
    pageDragging = 1;
    
    isTap = YES;
    
    startPageOffsetx = 0;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.footerView];
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
    if (totalPages == 1) {
        [self labels:1];
//        ((AppLabel *)self.labels[0]).label.text = [_readData strAtPos:0 isReverse:NO];
        ((AppLabel *)self.labels[0]).label.text = _readData.array[0];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CONTENT_HEIGHT);
    }else {
        [self labels:totalPages];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * totalPages, CONTENT_HEIGHT);
    }

    _footerView.text = [NSString stringWithFormat:@"%d/%d",  1, totalPages];
//
//    int lineCharsCount = floor(CONTENT_WIDTH / FONT_SIZE_CONTENT);
//    int linesCount = floor(CONTENT_HEIGHT / FONT_SIZE_CONTENT);
//    
//    
//    NSLog(@"byte len := %d", 3*lineCharsCount*linesCount);
//    NSLog(@"char count := %d", lineCharsCount*linesCount);
//
//
//    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
//    
//    NSString *sql1 = [NSString stringWithFormat:
//                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//                      @"PERSONINFO", @"name", @"age", @"address", @"张三", @"23", @"西城区"];
//    
//    NSString *sql2 = [NSString stringWithFormat:
//                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//                      @"PERSONINFO", @"name", @"age", @"address", @"老六", @"20", @"东城区"];
//    
//    SqlOP *sql = [[SqlOP alloc] init];
//    [sql execSql:sqlCreateTable];
//    [sql execSql:sql1];
//    
//    [sql test];
//    
//    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
}

- (void)moveLabel {
    int theLabel = 0;
    unsigned long skip = 0;
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0) {
        if (pageDragging % 3 == 0) {
            theLabel = 2;
        }else {
            theLabel = pageDragging % 3 - 1;
        }
        
        if (pageDragging + 2 > totalPages - 1) {
            return;
        }
        
         ((AppLabel *)self.labels[theLabel]).label.text = [_readData skip:0 isReverse:NO];

    }else if (direction < 0) {
        if (pageDragging % 3 == 2) {
            theLabel = 0;
            NSString *s1 = ((AppLabel *)self.labels[1]).label.text;
            NSString *s2 = ((AppLabel *)self.labels[2]).label.text;
            skip = [s1 dataUsingEncoding:NSUTF8StringEncoding].length + [s2 dataUsingEncoding:NSUTF8StringEncoding].length;

        }else {
            theLabel = pageDragging % 3 + 1;
            
            if (theLabel == 1) {
                NSString *s0 = ((AppLabel *)self.labels[0]).label.text;
                NSString *s2 = ((AppLabel *)self.labels[2]).label.text;
                skip = [s0 dataUsingEncoding:NSUTF8StringEncoding].length + [s2 dataUsingEncoding:NSUTF8StringEncoding].length;

            }else {
                NSString *s0 = ((AppLabel *)self.labels[0]).label.text;
                NSString *s1 = ((AppLabel *)self.labels[1]).label.text;
                skip = [s1 dataUsingEncoding:NSUTF8StringEncoding].length + [s0 dataUsingEncoding:NSUTF8StringEncoding].length;

            }
        }

        if (pageDragging - 2 < 0) {
            return;
        }
        
         ((AppLabel *)self.labels[theLabel]).label.text = [_readData skip:skip isReverse:YES];

    }else {
        return;
    }
    
    CGRect rect = CGRectMake((pageDragging + 2)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
    ((AppLabel *)self.labels[theLabel]).frame = rect;
}

- (void)updateFooter {
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    
    if (direction > 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  ++ pageDragging, totalPages];
    }else if (direction < 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  -- pageDragging, totalPages];
    }
    
}

#pragma property

- (NSArray *)labels:(NSInteger)n {
    if (_labels == nil) {
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        if (n > 2) {
            n = 3;
        }
        
        for (int i = 0; i < n; i++) {
            AppLabel *label = [[AppLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
//            label.label.text = [self updateText:i];
            label.label.text = [_readData skip:0 isReverse:NO];
            [a addObject:label];
            
//            if (i == 0) {
//                label.backgroundColor = [UIColor redColor];
//            }else if (i == 1) {
//                label.backgroundColor = [UIColor greenColor];
//            }else {
//                label.backgroundColor = [UIColor blueColor];
//            }
            
            [self.scrollView addSubview:label];
        }
        
        _readData.curPage = 1;
        
        _labels = a;
    }
    
    return _labels;
    
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        _headerView.backgroundColor = [UIColor grayColor];
    }
    
    return _headerView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, 20)];
        _footerView.backgroundColor = [UIColor grayColor];
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  pageDragging, totalPages];
        _footerView.textColor = [UIColor whiteColor];
        
    }
    
    return _footerView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, CONTENT_HEIGHT)];
        _scrollView.backgroundColor = [UIColor grayColor];
//        _scrollView.touchesdelegate = self;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = 0.0;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
}

#pragma mark

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startPageOffsetx = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    int pageDidDrag = floor(startPageOffsetx / SCREEN_WIDTH); // from 0
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0 && pageDidDrag < totalPages - 1) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDidDrag+1), 0) animated:NO];
        [self moveLabel];
    }else if (direction < 0 && pageDidDrag > 0){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDidDrag - 1), 0) animated:NO];
        [self moveLabel];
    }
    
    [self updateFooter];
    
//    NSLog(@"currentpage = %d, direction = %d, totalpages = %d, offsetx = %f, width = %f, len = %ld",
//          currentPage, direction, totalPages, scrollView.contentOffset.x, scrollView.contentSize.width, len);
    
    NSLog(@"pos = %lld, %d", _readData.dataPosition, _readData.curPage);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dragging = NO;
}

@end
