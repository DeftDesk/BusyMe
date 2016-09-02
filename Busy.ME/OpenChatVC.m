//
//  OpenChatVC.m
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "OpenChatVC.h"
#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ChatReceiverCell.h"
#import "ChatSenderCell.h"
#import "Reachability.h"
//from = sender
//to = receiver

@interface OpenChatVC ()<APIMasterDelegate>

@end
typedef NS_ENUM(NSInteger, kActionType)
{
    kActionTypeGetMessage,
    kActionTypeSendMessage,
};

kActionType actionTypeChat;
@implementation OpenChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageReceived:) name:@"pushNotification" object:nil];

    self.lblSenderName.text = [self.strSenderName capitalizedString];
    [self.lblSenderName setAdjustsFontSizeToFitWidth:true];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    
    [self.tblChatFrnd addGestureRecognizer:tap];
    self.tblChatFrnd.showsHorizontalScrollIndicator = NO;
    self.tblChatFrnd.showsVerticalScrollIndicator = NO;
    self.tblChatFrnd.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.chatArray = [[NSMutableArray alloc]init];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(getMessageDataFromServer)
        forControlEvents:UIControlEventValueChanged];
    page = 1;
    
    [self.tblChatFrnd addSubview:self.refresh];
    
    
    [self registerForKeyboardNotifications];
    
   
    [self fetchChatMessages];

}
-(void)viewTapped {
    [self.txtVw resignFirstResponder];
    [self.txtMessageField resignFirstResponder];
    [self.txtFld resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMessageDataFromServer
{
    page += 1;
    self.responseChatDict = @{@"action":@"get_message_list",
                              @"user_id":[CommonMethods accessUserDefaultsWithKey:kUserId],@"friend_id":self.strFriendUserId,@"min":[NSString stringWithFormat:@"%ld",(long)page],@"max":@"50"};
    
    NSLog(@"%@",self.responseChatDict);

    [self fetchChatMessages];
}
-(void)fetchChatMessages
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Check Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        return;
    }
    if (![self.refresh isRefreshing])
    {
        isRefresh = false;
        
    }else{
        isRefresh =true;
    }

    [self.tblChatFrnd reloadData];
    actionTypeChat = kActionTypeGetMessage;
    [self sendRequestToWeb];
    
}
-(IBAction)OpenChatBack:(id)sender
{
    [self.delegate updateLastMessageWithinputString:[NSString stringWithFormat:@"%@",self.chatArray[self.chatArray.count-1][@"message"]]];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)scrollToTopMethod {
    if (self.chatArray.count != 0) {
        
        [self.tblChatFrnd scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark
#pragma mark <UITextViewInput Accessory View Methods>
#pragma mark

-(void)createInputAccessoryView {
    
    self.keyboardView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 282, self.view.frame.size.width, 46)];
    self.keyboardView.backgroundColor = [UIColor colorWithRed:239.0f/255 green:239.0f/255 blue:244.0f/255 alpha:1];
    
    self.txtMessageField = [[UITextField alloc]initWithFrame:CGRectMake(10, 6, self.view.frame.size.width - 55, 32)];
    self.txtMessageField.placeholder = @"Type Message here";
    self.txtMessageField.font = [UIFont systemFontOfSize:14];
    self.txtMessageField.delegate = self;
    self.txtMessageField.borderStyle = UITextBorderStyleRoundedRect;
    self.txtMessageField.userInteractionEnabled = false;
    
    self.txtVw = [[UITextView alloc]initWithFrame:self.txtMessageField.frame];
    self.txtVw.font = [UIFont systemFontOfSize:14];
    self.txtVw.delegate = self;
    self.txtVw.backgroundColor = [UIColor clearColor];
    
    
    self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDone.frame = CGRectMake(self.view.frame.size.width - 35, 10, 30, 25);
   // [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [self.btnDone setImage:[UIImage imageNamed:@"sendMessage"] forState:UIControlStateNormal];
   // self.btnDone.backgroundColor = [UIColor colorWithRed:18.0f/255 green:86.0f/255 blue:135.0f/255 alpha:1];
    self.btnDone.backgroundColor = [UIColor clearColor];
    [self.btnDone addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.btnDone.titleLabel.textColor = [UIColor whiteColor];
//    self.btnDone.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.btnDone.layer.cornerRadius = 4;
    
    [self.keyboardView addSubview:self.txtMessageField];
    [self.keyboardView addSubview:self.btnDone];
    
    [self.keyboardView addSubview:self.txtVw];
    
}

-(void)doneBtnClicked
{
    if (self.txtVw.text.length != 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        NSMutableString *str = [[NSMutableString alloc]initWithString:self.txtVw.text];
        for (int i = self.txtVw.text.length; i > 0; i--) {
            if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self.txtVw.text characterAtIndex:i - 1]]) {
                [str replaceCharactersInRange:NSMakeRange(str.length - 1 , 1) withString:@""];
            }
            else {
                break;
            }
        }
        
        self.txtVw.text = str;
        NSDictionary *dict=[[NSDictionary alloc]init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        NSString *selectedUserid = [CommonMethods accessUserDefaultsWithKey:kUserId];
        
        
            
            NSString *strSenderName=@"";
            NSString *strSenderTime=@"";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
            strSenderTime = [formatter stringFromDate:[NSDate date]];
            strSenderName =@"test";
            
            NSURL *imageUrl=[[NSURL alloc]initWithString:@""];
            
            for (int i =0; i < self.chatArray.count; i++)
            {
                if ([self.chatArray[i][@"toid"] isEqualToString:selectedUserid])
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
                    strSenderTime = [formatter stringFromDate:[NSDate date]];
                    
                    //strSenderName =[NSString stringWithFormat:@"%@",self.chatArray[i][@"sender_name"]];
                    imageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.chatArray[i][@"tourl"]]];
                    

                    break;
                }else{
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
                    strSenderTime = [formatter stringFromDate:[NSDate date]];
                    //strSenderName =@"test";
                }
                
            }
            
            dict = @{@"fromid":self.strFriendUserId,@"toid":selectedUserid,@"message":self.txtVw.text,@"time":strSenderTime,@"tourl":imageUrl};//
            
        
        
        [self.chatArray addObject:dict];
        
        [self performSelectorInBackground:@selector(sendMessageToUser) withObject:nil];
        
        
        [self.tblChatFrnd reloadData];
        
        self.txtFld.text = @"";
        self.txtVw.text = @"";
        
        [self textViewDidChange:self.txtVw];
        
    }
    else {
        self.txtFld.text = @"";
        self.txtVw.text = @"";
        [self.txtVw resignFirstResponder];
        [self.txtMessageField resignFirstResponder];
        [self.txtFld resignFirstResponder];
        
    }
    
    
    [self.tblChatFrnd reloadData];
    
    
    
}
-(void)sendMessageToUser
{
    // [AppUtils showProgress];
    
    
    [self.tblChatFrnd reloadData];
    actionTypeChat = kActionTypeSendMessage;
    [self sendRequestToWeb];
    //[self scrollToTopMethod];
    
    
    /*[[RequestManager shared] requestWithAttributes:self.responseSendMsgDict
                                        completion:^(NSDictionary *responseDict)
     {
         
         if (responseDict != nil) {
             //for user id 66
             
             // [AppUtils dismissProgress];
             
             // [self performSelectorOnMainThread:@selector(fetchChatMessages) withObject:nil waitUntilDone:true];
             
         }else {
             //[AppUtils dismissProgress];
             
             [self._tblChatFrnd reloadData];
         }
     }];*/
    
}

#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *selectedUserid = [CommonMethods accessUserDefaultsWithKey:kUserId];

    if (actionTypeChat == kActionTypeSendMessage)
    {
        [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=add_msg&fromid=%@&toid=%@&message=%@",self.strFriendUserId,selectedUserid,self.txtVw.text]];
    }
    else if(actionTypeChat == kActionTypeGetMessage)
    {
        [apimaster sendGetNewRequestToWebWithString:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=getallmessage&fromid=%@&toid=%@&pagesize=20&pageno=%ld",self.strFriendUserId,selectedUserid,page]];
    }
    
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (actionTypeChat == kActionTypeSendMessage)
    {
        if ([[response objectForKey:@"status"]boolValue])
        {
            if ([[response allKeys] containsObject:@"chat"])
            {
                
                    [self performSelectorOnMainThread:@selector(fetchChatMessages) withObject:nil waitUntilDone:true];
            }
            else{
            }
            
        }
    }else if(actionTypeChat == kActionTypeGetMessage)
    {
        if ([[response objectForKey:@"status"]boolValue])
        {
            if ([[response allKeys] containsObject:@"chat"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.refresh endRefreshing];
//                    [self.refresh removeFromSuperview];
//                    self.refresh = nil;
                    
                    
                });
               
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                
                [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                
                NSArray *arr =[[NSArray alloc]initWithArray:[response objectForKey:@"chat"]];
                
                NSArray *previousChat = [[NSArray alloc]initWithArray:self.chatArray];
                self.chatArray = [[NSMutableArray alloc]init];
               
                for (int i = 0; i < arr.count; i++)
                {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary: [arr objectAtIndex:i]];
                    if ([[newDict objectForKey:@"message"]isEqualToString:@""])
                    {
                        [newDict removeObjectForKey:@"message"];
                        [newDict setObject:@"hello" forKey:@"message"];
                    }else{
                        [self.chatArray addObject:[arr objectAtIndex:i]];

                    }

                    
                }
                
                if (previousChat.count > 0) {
                    //[self.chatArray addObjectsFromArray:previousChat];
                }
                [self.tblChatFrnd performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true];

            }
            else{
                [self.refresh endRefreshing];
                [self.tblChatFrnd reloadData];
            }
            
        }else{
            [self.refresh endRefreshing];
            [self.tblChatFrnd reloadData];
        }

        if (!isRefresh)
        {
            [self performSelectorOnMainThread:@selector(scrollToTopMethod) withObject:nil waitUntilDone:false];
        }
    }
    
    
}


#pragma mark
#pragma mark <UITextField Delegate Methods>
#pragma mark

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.txtFld) {
        
        [self createInputAccessoryView];
        
        [textField setInputAccessoryView:self.keyboardView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.tblVwBottomLayout.constant = keyboardHeight;
        [self.view layoutIfNeeded];
        
        [self scrollToTopMethod];
        [UIView commitAnimations];
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView commitAnimations];
    
}
#pragma mark
#pragma mark <UITextView Delegate Methods>
#pragma mark

- (void)textViewDidChange:(UITextView *)textView
{
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    CGRect vwframe = self.keyboardView.frame;
    CGFloat vwWidth = vwframe.size.width;
    
    vwframe.size = CGSizeMake(vwWidth,newSize.height + 14);
    
    //change the frame of textview according to text
    if (newSize.height > 30 && newSize.height < 80) {
        
        textView.frame = newFrame;
        self.txtMessageField.frame = newFrame;
        vwframe.origin.y = vwframe.origin.y  - (vwframe.size.height - self.keyboardView.frame.size.height);
        self.keyboardView.frame = vwframe;
        inputAccessoryVwHeight = vwframe.size.height;
        
        //scroll tableview to last row
        
        self.tblVwBottomLayout.constant = keyboardHeight - vwframe.origin.y;
        [self.view layoutIfNeeded];
        [self scrollToTopMethod];
    }
    else if (newSize.height > 80) {
        
        self.keyboardView.frame = CGRectMake(0, -34.5, self.view.frame.size.width, 80.5);
        inputAccessoryVwHeight = 80.5;
        self.tblVwBottomLayout.constant = keyboardHeight - vwframe.origin.y;
        [self.view layoutIfNeeded];
        [self scrollToTopMethod];
    }
    
    
    for (NSLayoutConstraint *constraint in [self.txtFld.inputAccessoryView constraints]) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = inputAccessoryVwHeight;
            [self.txtFld.inputAccessoryView layoutIfNeeded];
            break;
        }
    }
    
    
    // Change the button from Done to Send
//    if (self.txtVw.text.length == 0) {
//        self.btnDone.backgroundColor = [UIColor colorWithRed:18.0f/255 green:86.0f/255 blue:135.0f/255 alpha:1];
//        [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
//    } else {
//        self.btnDone.backgroundColor = [UIColor colorWithRed:122.0f/255 green:201.0f/255 blue:69.0f/255 alpha:1];
//        [self.btnDone setTitle:@"Send" forState:UIControlStateNormal];
//    }
    
    [self.txtVw setInputAccessoryView:self.keyboardView];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Add or remove placeholder
    if (textView.text.length == 1 && [text isEqualToString:@""]) {
        self.txtMessageField.placeholder = @"Type Message here";
        self.txtMessageField.text =  @"";
    }
    else if (textView.text.length == 0 && [text isEqualToString:@""]) {
        self.txtMessageField.placeholder = @"Type Message here";
        self.txtMessageField.text =  @"";
    }
    else {
        self.txtMessageField.placeholder = @"";
        self.txtMessageField.text =  @"";
    }
    
    if ([text isEqualToString:@"\n"])
    {
        //[self doneBtnClicked];
    }
    
    
    
    return YES;
}

#pragma mark
#pragma mark <Keyboard Appearence Methods>
#pragma mark

- (void)keyboardWasShown:(NSNotification *)notification {
    if (!isShown) {
        isShown = true;
        NSDictionary *info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        // Write code to adjust views accordingly using deltaHeight
        keyboardHeight = kbSize.height;
        [self.txtVw becomeFirstResponder];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    isShown = false;
    self.tblVwBottomLayout.constant = 44;
    [self.view layoutIfNeeded];
    [self scrollToTopMethod];
}

-(void)keyboardframeChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // Write code to adjust views accordingly using deltaHeight
    keyboardHeight = kbSize.height;
    NSLog(@"%f",keyboardHeight);
    [self textViewDidChange:self.txtVw];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardframeChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}



-(void)messageReceived:(id)result
{
    NSNotification *noti = result;
    
    NSDictionary *dict = noti.userInfo;
    
//    if (!self.isGroupChat && [self.strFriendUserId isEqualToString:[dict valueForKey:@"senderId"]])
//    {
        [self.chatArray addObject:dict];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        [self.tblChatFrnd reloadData];
        
        [self performSelector:@selector(scrollToTopMethod) withObject:nil afterDelay:0.2];
//    }else
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"notificationReceived"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [[NSUserDefaults standardUserDefaults]setValue:dict forKey:@"notificationPayload"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ : %@",dict[@"username"],dict[@"message"]] message:@"" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Chat Now", nil];
//        [alert show];
//        
//    }
    
}

#pragma mark
#pragma mark <UITableView Delegate Methods>
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        if (indexPath.row % 2 == 0) {
    
    
        if ([self.chatArray[indexPath.row][@"toid"] isEqualToString:[CommonMethods accessUserDefaultsWithKey:kUserId]])
        {
            
            ChatSenderCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
            
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatSenderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageText:self.chatArray[indexPath.row]];
            
            NSString *strLastTime = [NSString stringWithFormat:@"%@",self.chatArray[self.chatArray.count -1][@"time"]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *dte = [dateFormat dateFromString:strLastTime];
            [dateFormat setDateFormat:@"dd MMM hh:mma"];
//            self.titleLblHeight.constant = 37.0f;
//            [self.view layoutIfNeeded];
//            self.lblLastSeen.text = [NSString stringWithFormat:@"Last Seen at %@",[dateFormat stringFromDate:dte]];
            
            
            return cell;
        }
        else {
            ChatReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatReceiverCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageText:self.chatArray[indexPath.row]];
            
            NSString *strLastTime = [NSString stringWithFormat:@"%@",self.chatArray[self.chatArray.count -1][@"time"]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *dte = [dateFormat dateFromString:strLastTime];
            [dateFormat setDateFormat:@"dd MMM hh:mma"];
//            self.titleLblHeight.constant = 37.0f;
//            [self.view layoutIfNeeded];
//            self.lblLastSeen.text = [NSString stringWithFormat:@"Last Seen at %@",[dateFormat stringFromDate:dte]];
            return cell;
        }
        
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   
        NSString *messageStr = self.chatArray[indexPath.row][@"message"];
        NSString *timeStr = self.chatArray[indexPath.row][@"time"];
        
        CGSize constrainedSize = CGSizeMake(190, 9999);
        CGSize timedSize = CGSizeMake(190, 12);
        
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            constrainedSize = CGSizeMake(280, 9999);
            timedSize = CGSizeMake(280, 12);
            
        }
        
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
        
        NSDictionary *timeAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11], NSFontAttributeName, nil];
        
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:messageStr attributes:attributesDictionary];
        
        
        NSMutableAttributedString *stringTime = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:timeAttributesDictionary];
        
        CGRect requiredFrame = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        
        CGRect requiredFrameTime = [stringTime boundingRectWithSize:timedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize size;
        
        if (requiredFrame.size.width > requiredFrameTime.size.width)
        {
            size = requiredFrame.size;
        }
        else if (requiredFrameTime.size.width > requiredFrame.size.width)
        {
            size = requiredFrameTime.size;
        }
        
        if (size.height > 16)
        {
            return requiredFrame.size.height + 60;
        }
        return 65;
   
}


#pragma mark
#pragma mark <Get Height According Text Methods>
#pragma mark

// Get height According to text
-(CGFloat)getHeightOfTextWithString:(NSString*)textStr WithWidth:(int)width{
    CGSize constrainedSize = CGSizeMake(width  , 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:13.0], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textStr attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return requiredHeight.size.height;
    
}


@end
