//
//  ZBookContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookContentViewController.h"
#import "ZBookInfo.h"
#import "ZDBManager.h"
#import "ZTouchScrollView.h"
#import "ZLabel.h"
#import "ZUtil.h"
#import "ZBookManager.h"

@interface ZBookContentViewController () <UIScrollViewDelegate> {
    int totalPages;
    int startPageOffsetx;
    int pageDragging;
}
@property (nonatomic, strong) NSArray* pagesIndexs;
@property (nonatomic, strong) UILabel* headerView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) ZTouchScrollView* scrollView;
@property (nonatomic, strong) UIView* toolView;

@property (nonatomic, strong) ZLabel* label1;
@property (nonatomic, strong) ZLabel* label2;
@property (nonatomic, strong) ZLabel* label3;
@end

@implementation ZBookContentViewController

- (instancetype)initWith:(ZBookInfo*)bookInfo
{
    self = [super init];
    if (self) {
        _bookInfo = bookInfo;
        _pagesIndexs = [[ZDBManager manager] getPageIndexs:_bookInfo.bookID];
        
        totalPages = (int)_pagesIndexs.count;
        startPageOffsetx = 0;
        pageDragging = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.toolView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 

- (void)updateHeader {
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    
    if (direction > 0) {
        self.headerView.text = [NSString stringWithFormat:@"%d/%d   %@",  ++ pageDragging, totalPages - 1, self.bookInfo.bookName];
    }else if (direction < 0) {
        self.headerView.text = [NSString stringWithFormat:@"%d/%d   %@",  -- pageDragging, totalPages - 1, self.bookInfo.bookName];
    }

}

- (void)moveLabel {
    int theLabel = 0;
    int thePage = 0;
    BOOL isReverse = NO;
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0) {
        thePage = pageDragging + 2;
        theLabel = (thePage) % 3;
    }else if (direction < 0) {
        thePage = pageDragging - 2;
        if (thePage < 0) {
            return;
        }
        
        theLabel = (thePage) % 3;
        isReverse = YES;
    }
    
    if (thePage >= totalPages) {
        return;
    }
    
    NSString * s = [ZUtil pageContent:self.bookInfo.bookID offset:self.pagesIndexs[thePage] offset2:self.pagesIndexs[thePage+1]];
    if (s == nil) {
        return;
    }
    
    if (theLabel == 0) {
        self.label1.text = s;
        CGRect rect = CGRectMake((thePage)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        self.label1.frame = rect;
    }else if (theLabel == 1) {
        self.label2.text = s;
        CGRect rect = CGRectMake((thePage)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        self.label2.frame = rect;
    }else {
        self.label3.text = s;
        CGRect rect = CGRectMake((thePage)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        self.label3.frame = rect;
    }
}

- (void)tap:(UIButton*)button {
    switch (button.tag) {
        case 0:{
            
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startPageOffsetx = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageDragging = floor(startPageOffsetx / SCREEN_WIDTH); // from 0
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0 && pageDragging < totalPages - 1) {
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging + 1), 0) animated:YES];
        [self moveLabel];
    }else if (direction < 0 && pageDragging > 0){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging - 1), 0) animated:YES];
        [self moveLabel];
    }
    
    [self updateHeader];
}


#pragma mark setter getter

- (UILabel *)headerView {
    if (_headerView == nil) {
        _headerView = [[UILabel alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _headerView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, 20)];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _footerView;
}

- (ZTouchScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[ZTouchScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, CONTENT_HEIGHT)];
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = 1.0;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        
        int c = 3;
        if (self.pagesIndexs.count < 3) {
            c = (int)self.pagesIndexs.count;
        }
        for (int i = 0; i < c; i++) {
            if (i == 0) {
                _label1 = [[ZLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
                _label1.font = [ZBookManager manager].fontFamily;
                _label1.fontSize = [[[ZBookManager manager] fontSize] floatValue];
                _label1.line = [[ZBookManager manager].lineSpace floatValue];
                _label1.paragraph = [[ZBookManager manager].paragraphSpace floatValue];
                _label1.text = [ZUtil pageContent:self.bookInfo.bookID offset:self.pagesIndexs[0] offset2:self.pagesIndexs[1]];
                [_scrollView addSubview:_label1];
            }
            if (i == 1) {
                _label2 = [[ZLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
                _label2.fontSize = [[[ZBookManager manager] fontSize] floatValue];
                _label2.line = [[ZBookManager manager].lineSpace floatValue];
                _label2.paragraph = [[ZBookManager manager].paragraphSpace floatValue];

                _label2.text = [ZUtil pageContent:self.bookInfo.bookID offset:self.pagesIndexs[1] offset2:self.pagesIndexs[2]];
                [_scrollView addSubview:_label2];
            }
            if (i == 2) {
                _label3 = [[ZLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
                _label3.fontSize = [[[ZBookManager manager] fontSize] floatValue];
                _label3.line = [[ZBookManager manager].lineSpace floatValue];
                _label3.paragraph = [[ZBookManager manager].paragraphSpace floatValue];

                _label3.text = [ZUtil pageContent:self.bookInfo.bookID offset:self.pagesIndexs[2] offset2:self.pagesIndexs[3]];
                [_scrollView addSubview:_label3];
            }

        }
    }
    
    return _scrollView;
}

- (UIView *)toolView {
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        _toolView.backgroundColor = UIColorFromHex(0xF3F3F3);
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
        
        [_toolView.layer addSublayer:layer];
        
        CGFloat w = 60;
        CGFloat h = 30;
        CGFloat left = (SCREEN_WIDTH - w*4)/5;
        
        UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(left, 10, w, h)];
        b1.tag = 0;
        [b1 setTitle:@"条目" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b1 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(left*2+w, 10, w, h)];
        b2.tag = 1;
        [b2 setTitle:@"字长背景" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b2 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(left*3+2*w, 10, w, h)];
        b3.tag = 2;
        [b3 setTitle:@"书论" forState:UIControlStateNormal];
        b3.titleLabel.font = [UIFont systemFontOfSize:14];
        [b3 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b3 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_toolView addSubview:b1];
        [_toolView addSubview:b2];
        [_toolView addSubview:b3];
        
    }
    
    return _toolView;
}


@end
