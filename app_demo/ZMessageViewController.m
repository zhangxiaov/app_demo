//
//  ZMessageViewController.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageViewController.h"
#import "ZMessageInputView.h"
#import "AppConfig.h"
#import "ZMessageList.h"
#import "ZMessageDataSource.h"
#import "ZMessageModel.h"
#import "ZMessageCell.h"

static const NSString* DEFAULT_PLACE_HOLDER = @"我来说两句";

static const CGFloat PADDING_FOR_VIEW_V = 5;

static const CGFloat MIN_HEIGHT_FOR_INPUT_VIEW = 36;

const CGFloat kGroupMinInputBarHeight = 46.0f;


@interface ZMessageViewController () <ZMessageListDelegate, ZMessageInputViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ZMessageInputView* inputBarView;
@property (nonatomic, strong) ZMessageList* messageList;
@property (nonatomic, strong) ZMessageSession* messageSession;
@property (nonatomic, strong) ZMessageDataSource* dataSource;

@property (nonatomic) ZMessageLastPosition lastMessagePostion;
@property (nonatomic) ZMessageTableScroll tableScrollWhenShowPad;
@end

@implementation ZMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊";
    _lastMessagePostion = ZMessageLastPositionAtBottom;
    [self.view addSubview:self.tableView];
    [self.messageList fetchLatestMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inputBarView prepareToShow:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputBarView disappear];
}

#pragma mark private

- (void)refreshLastMessage {
    if (![self.messageList fetchLatestMessages]) {
        return;
    }
    
    [self.tableView reloadData];
    
    switch (_lastMessagePostion) {
        case ZMessageLastPositionAtBottom:
            ;
            CGFloat top = statusBarHeight + self.navigationController.navigationBar.frame.size.height;
            CGFloat padHeight = SCREEN_HEIGHT - self.inputBarView.frame.origin.y;
            CGFloat offset = self.tableView.bounds.origin.y + (top + self.tableView.contentSize.height - SCREEN_HEIGHT) + padHeight + MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:NO];
            break;
        case ZMessageLastPositionAtTop:
            ;
        default:
            break;
    }
}

- (void)refreshOldMessage {
    if (![self.messageList fetchFormerMessages]) {
        return;
    }
    
    [self.tableView reloadData];
    
    switch (_lastMessagePostion) {
        case ZMessageLastPositionAtBottom:
            ;
            CGFloat top = statusBarHeight + self.navigationController.navigationBar.frame.size.height;
            CGFloat padHeight = SCREEN_HEIGHT - self.inputBarView.frame.origin.y;
            CGFloat offset = self.tableView.bounds.origin.y + (top + self.tableView.contentSize.height - SCREEN_HEIGHT) + padHeight + MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:NO];
            break;
        case ZMessageLastPositionAtTop:
            ;
        default:
            break;
    }
}

- (void)needMoveTableWhenSendMessage {
    
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGFloat offset = MAX(self.tableView.contentSize.height - CGRectGetHeight(self.tableView.bounds), 0);
    [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:animated];
    
    //是否要移动table
    [self needMoveTableWhenSendMessage];
}

- (void)refreshTableAndScrollToBottom:(BOOL)toBottom {
    __weak ZMessageViewController* weakSelf = self;
    [self.dataSource reloadItemsWithCompletion:^{
        [weakSelf.tableView reloadData];
        
        if (toBottom) {
            [weakSelf scrollToBottomAnimated:NO];
        }
    }];
}

- (void)sendMessage:(ZMessageModel*)message {
    
    //本地展示
    [self.messageList.messages addObject:message];
    [self.tableView reloadData];
    [self scrollToBottom:YES];
    
    //送至服务器
    [self.messageList sendMessage:message];
}

- (void)uploadOldData {
    
}

- (void)downloadLastData {
    
}

- (void)scrollToBottom:(BOOL)animated {
    CGFloat offset = MAX(self.tableView.contentSize.height - CGRectGetHeight(self.tableView.bounds), 0);
    [self.tableView setContentOffset:CGPointMake(0.0, offset) animated:animated];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:[ZMessageCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[ZMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ZMessageCell reuseIdentifier]];
    }
    
    [cell updateWithMessage:self.messageList.messages[indexPath.row]];

    return cell;
}

#pragma mark ZMessageListDelegate

- (void)list:(ZMessageList *)list didRequestLatestMessages:(NSArray *)messages {
    if (messages.count < 10) {
        
    }
    
//    [self refreshTableAndScrollToBottom:YES];
    [self scrollToBottom:NO];

}

- (void)list:(ZMessageList *)list didRequestFormerMessages:(NSArray *)messages {
    
}

- (void)list:(ZMessageList *)list didPushedWithMessages:(NSArray *)messages {
    
}

#pragma mark ZMessageInputViewDelegate

- (void)inputView:(ZMessageInputView *)inputView didTextSendWithText:(NSString *)text {
    ZMessageModel* message = [[ZMessageModel alloc] init];
    message.text = text;
    message.messageType = ZMessageTypeText;
    
    [self sendMessage:message];
}

#pragma mark setter

- (ZMessageList *)messageList {
    if (_messageList == nil) {
        _messageList = [[ZMessageList alloc] initWithSession:self.messageSession delegate:self];
    }
    
    return _messageList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kGroupMinInputBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    return _tableView;
}

- (ZMessageInputView *)inputBarView {
    if (!_inputBarView) {
        _inputBarView = [[ZMessageInputView alloc] initWithType:ZMessageInputViewTypeChat andWithPlaceHolder:@"xxxxx"];
        _inputBarView.delegate = self;
    }
    
    return _inputBarView;
}

- (ZMessageDataSource *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[ZMessageDataSource alloc] initWithModel:self.messageList];
    }
    return _dataSource;
}

@end
