//
//  TWFXToolBarViewController.m
//  DemoToolBar
//
//  Created by Lion User on 13-1-19.
//  Copyright (c) 2013年 Lion User. All rights reserved.
//

#import "TWFXToolBarViewController.h"

@interface TWFXToolBarViewController ()

@end

@implementation TWFXToolBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建toolbar
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 420.0f, 320.0f, 40.0f) ];
        
        //创建barbuttonitem
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(test:)];
        
        //创建barbuttonitem
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:nil];
        
        //创建一个segmentController
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"牛扒", @"排骨", nil]];
        
        //设置style
        [seg setSegmentedControlStyle:UISegmentedControlSegmentCenter];
        
        
        [seg addTarget:self action:@selector(segmentControllerItem:) forControlEvents:UIControlEventValueChanged];
        
        //创建一个内容是view的uibarbuttonitem
        UIBarButtonItem *itemSeg = [[UIBarButtonItem alloc] initWithCustomView:seg];
        
        //创建barbuttonitem,样式是flexible,这个种barbuttonitem用于两个barbuttonitem之间
        //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        //把item添加到toolbar里
        [toolBar setItems:[NSArray arrayWithObjects:item1,flexible,itemSeg,flexible,item2, nil] animated:YES];
        
        //把toolbar添加到view上
        [self.view addSubview:toolBar];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)test:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *) sender;
    NSString *title = [NSString stringWithFormat:@"%@ 被选中了",item.title];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention" message:title delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}


-(void)segmentControllerItem:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    NSInteger index = seg.selectedSegmentIndex;
    NSString *message;
    if (index == 0) {
        message = @"你选了牛扒";
    }
    else
    {
        message = @"你选了排骨";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attenton" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end