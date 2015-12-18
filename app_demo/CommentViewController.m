//
//  CommentViewController.m
//  app_demo
//
//  Created by 张新伟 on 15/10/31.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "CommentViewController.h"
#import "Book.h"
#import "Comment.h"
#import "CommentCell.h"
#import "AppConfig.h"
#import "UIImage+UIColor.h"
#import "CommentTextView.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) UIActivityIndicatorView *aiv;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footerView;


@property (nonatomic, strong) NSMutableArray *tempData;
@end

@implementation CommentViewController

- (instancetype)initWithBook:(Book *)book
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBarHidden = NO;
        self.title = @"评论";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.backgroundColor = UIColorFromHex(0xF3F3F3);
        
        [self.view addSubview:self.aiv];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.footerView];

        
        [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:[CommentCell reuseIdentifier]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHidden)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wait];
    
    [self getData];
}

- (void)getData {
    NSString *s = @"http://localhost:8000/test";
    NSURL *url = [NSURL URLWithString:s];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self hideWait];
        
//        if (connectionError) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[connectionError localizedDescription] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
        
//        if (data) {
            _comments = [@[] mutableCopy];
//            NSArray *a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
        NSArray *a = self.tempData;
        
            for (int i = 0; i < a.count; i++) {
                NSDictionary *d = a[i];
                Comment *c = [[Comment alloc] init];
                c.commentId = [[d valueForKey:@"CommentId"] integerValue];
                c.commentContent = [d valueForKey:@"CommentContent"];
                c.author = [d valueForKey:@"Author"];
                c.bookId = [[d valueForKey:@"BookId"] integerValue];
                c.date = [d valueForKey:@"Date"];
                
                [_comments addObject:c];
            }
            
            NSLog(@"%@", a);
            
            [self.tableView reloadData];
//        }
    }];
}

- (CGFloat)getCellHeight:(NSInteger)row {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGRect rect = [((Comment *)self.comments[row]).commentContent boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    return rect.size.height;
}

#pragma mark UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeight:indexPath.row] + 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.comments) {
        return self.comments.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentCell reuseIdentifier]];
    cell.authorLabel.text = ((Comment *)self.comments[indexPath.row]).author;
    cell.dateLabel.text = ((Comment *)self.comments[indexPath.row]).date;
    cell.contentLabel.text = ((Comment *)self.comments[indexPath.row]).commentContent;
    
    CGRect rect = cell.contentLabel.frame;
    rect.size.height = [self getCellHeight:indexPath.row];
    [cell.contentLabel setFrame:rect];
    
    return cell;
}

#pragma mark event

- (void)doSend {
    
    NSDictionary *d = @{@"CommentId":@2,@"CommentContent":[CommentTextView share].textView.text,@"Author":@"zhangsan",@"BookId":@2,@"Date":@"today"};
    
    [self.tempData addObject:d];
    
    [CommentTextView share].textView.text = @"";
    
    [self doHidden];
    
    [self getData];
}

- (void)doHidden {
    CommentTextView *textView = [CommentTextView share];
    [textView.textView resignFirstResponder];
    textView.alpha = 0.0f;
}

- (void)showCommentView {
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CommentTextView *textView = [CommentTextView share];
    textView.fromViewController = self;
    [win addSubview:textView];
    
    textView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        textView.alpha = 1.0;
    }];
}

- (void)back {
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) performDismiss
{
//    [_baseAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void) wait
{
    // Create and add the activity indicator
    [self.aiv startAnimating];
    
    // Auto dismiss after 3 seconds
//    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:3.0f];
}

- (void)hideWait {
    [self.aiv stopAnimating];
}

#pragma mark set get 

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (UIActivityIndicatorView *)aiv {
    if (_aiv == nil) {
        _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _aiv.hidesWhenStopped = YES;
        _aiv.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0f, [UIScreen mainScreen].bounds.size.height/2 - 40.0f);
    }
    
    return _aiv;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40)];
        _footerView.backgroundColor = UIColorFromHex(0xEBEBEB);
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
        
        [_footerView.layer addSublayer:layer];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 80 - 30, 30)];
        [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button1 setTitle:@" 说点" forState:UIControlStateNormal];
        [button1 setTitleColor:UIColorFromHex(0xeee) forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        button1.layer.cornerRadius = 2.0;
        button1.layer.masksToBounds = YES;
        button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button1 addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width- 80 - 10, 5, 80, 30)];
        [button setTitle:@"原文" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x2166C2) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = UIColorFromHex(0xBDC6D1).CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 2.0;
        button.layer.masksToBounds = YES;
        
        [_footerView addSubview:button1];
        [_footerView addSubview:button];
    }
    
    return _footerView;
}

- (NSMutableArray *)tempData {
    if (!_tempData) {
        _tempData = [@[@{@"CommentId":@1,@"CommentContent":@"testtetetetetetetesttetetetetetetesttetetetetetetesttetetetetetetesttetetetetetetesttetetetetetetesttetetetetetetesttetetetetetetesttetetetetete",@"Author":@"zhangsan",@"BookId":@1,@"Date":@"2015-12-01"},@{@"CommentId":@2,@"CommentContent":@"test",@"Author":@"zhangsan",@"BookId":@2,@"Date":@"2015-12-02"}] mutableCopy];
    }
    
    return _tempData;
}

@end
