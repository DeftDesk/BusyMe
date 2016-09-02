//
//  OpenChatVC.h
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenChatVC;
@protocol OpenChatVCDelegate <NSObject>

-(void)updateLastMessageWithinputString:(NSString*)message;
@end

@interface OpenChatVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate>{
    NSInteger page;
    CGFloat keyboardHeight;
    CGFloat inputAccessoryVwHeight;
    NSString *strGroupMsg;
    BOOL isShown;
    BOOL isRefresh;
}
@property (strong, nonatomic) IBOutlet UILabel *lblSenderName;
@property (strong, nonatomic) NSString *strSenderName;
@property (strong, nonatomic) IBOutlet UITableView *tblChatFrnd;
@property (strong, nonatomic) NSString *strFriendUserId;

@property(weak, atomic) id <OpenChatVCDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *vwSend;
@property (weak, nonatomic) IBOutlet UITextField *txtFld;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblVwBottomLayout;
@property (strong, nonatomic) UIRefreshControl* refresh;
@property (strong, nonatomic) NSMutableArray *chatArray;

@property (strong, nonatomic) UIView *keyboardView;
@property (strong, nonatomic) UITextField *txtMessageField;

@property (strong, nonatomic) UITextView *txtVw;

@property (strong, nonatomic) UIButton *btnDone;

@property (strong,nonatomic) NSDictionary *responseChatDict;
@property (strong,nonatomic) NSDictionary *responseSendMsgDict;
-(IBAction)OpenChatBack:(id)sender;
@end
