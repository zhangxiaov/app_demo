//
//  ZMessageInputBarView.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZMessageInputViewType) {
    /**
     *  聊天的输入框
     */
    ZMessageInputViewTypeChat = 1,
    /**
     *  评论的输入框
     */
    ZMessageInputViewTypeComment,
    /**
     *  通知输入框
     */
    ZMessageInputViewTypeNotice,
    /**
     *  在线答疑输入框
     */
    ZMessageInputViewTypeQuestion
};

typedef NS_ENUM(NSInteger, ZMessageInputViewButtonType) {

    ZMessageInputViewButtonTypeText = 1,

    ZMessageInputViewButtonTypeVoice,

    ZMessageInputViewButtonTypeOther,
};

typedef NS_ENUM(NSInteger, ZMessageInputViewKeyboradType) {
    ZMessageInputViewKeyboradTypeNone = 0,
    ZMessageInputViewKeyboradTypeKeyPad,
    ZMessageInputViewKeyboradTypeAddPad,
    ZMessageInputViewKeyboradTypeVoicePad,
};

@class ZMessageInputView;

@protocol ZMessageInputViewDelegate <NSObject>
@optional
- (void)inputView:(ZMessageInputView*)inputView didTextSendWithText:(NSString*)text;

@end

@class ZGrowingTextView;
@class ZTextView;
@interface ZMessageInputView : UIView

@property (nonatomic, weak) id<ZMessageInputViewDelegate> delegate;
@property (nonatomic, strong) UIButton* voiceButton;
@property (nonatomic, strong) UIButton* otherButton;
@property (nonatomic) ZTextView* textView;
@property (nonatomic) BOOL useGrayView;

@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic) ZMessageInputViewKeyboradType keyboardType;

- (void)prepareToShow:(BOOL)useGrayView;
- (void)disappear;

- (instancetype)initWithType:(ZMessageInputViewType)type andWithPlaceHolder:(NSString*)placeHolder;

@end
