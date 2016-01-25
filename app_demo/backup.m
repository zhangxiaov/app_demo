//
//  backup.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "backup.h"

@implementation backup
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_WITH_NAME(@"MISNavigationAdd")
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(createGroup)];
//    [self getDataGroupList];
//    
//    //添加刷新
//    UIRefreshControl* control = [[UIRefreshControl alloc] init];
//    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.table addSubview:control];
//}
//
//- (void)refreshStateChange:(UIRefreshControl*)control
//{
//    control.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
//    
//    [self getDataGroupList];
//    
//    [control endRefreshing];
//}


//
//  MISAddFriendRequestController.m
//  edua
//
//  Created by zhangxinwei on 15/10/12.
//  Copyright (c) 2015年 aspire. All rights reserved.
//



//#pragma mark event
//
//-(void)textFiledEditChanged:(NSNotification *)obj {
//    UITextField *textField = (UITextField *)obj.object;
//    
//    NSString *toBeString = textField.text;
//    
//    NSString *lang = [textField.textInputMode primaryLanguage];
//    
//    if ([lang isEqualToString:@"zh-Hans"]){ // 简体中文输入
//        
//        //获取高亮部分
//        
//        UITextRange *selectedRange = [textField markedTextRange];
//        
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        
//        
//        
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        
//        if (!position)
//            
//        {
//            
//            if (toBeString.length > MAX_STARWORDS_LENGTH)
//                
//            {
//                
//                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不能超过10位哦!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                
//                [alert show];
//            }
//        }
//    }
//}
//
//
//#pragma mark UITextFieldDelegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (string.length == 0) {
//        return YES;
//    }
//    
//    if (range.location > MAX_STARWORDS_LENGTH) {
//        return NO;
//    }
//    
//    if (textField.text.length + string.length > MAX_STARWORDS_LENGTH) {
//        return NO;
//    }
//    
//    return YES;
//}


@end


@end
