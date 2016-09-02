//
//  ChatViewCell.h
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgDP;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

-(void)setFriendsChatDetails:(id)message;
@end
