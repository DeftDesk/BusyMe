//
//  ChatSenderCell.h
//  Top10
//
//  Created by Gill on 24/08/15.
//  Copyright (c) 2015 Gill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatSenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgVwSender;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImgVw;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwTick;
@property (weak, nonatomic) IBOutlet UIImageView *imgSenderUser;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblWidth;

-(void)setMessageText:(id)message;

@end
