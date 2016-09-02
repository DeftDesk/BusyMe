//
//  ChatViewCell.m
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ChatViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation ChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgDP.layer.cornerRadius = self.imgDP.frame.size.width/2;
    self.imgDP.clipsToBounds = YES;
    self.imgDP.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.imgDP.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFriendsChatDetails:(id)message{
    self.lblName.text = [[message objectForKey:@"name"]capitalizedString];
    self.lblMessage.text = [message objectForKey:@"message"];
    NSString *timeStr = message[@"time"];
    if (timeStr == nil || timeStr == (id)[NSNull null]) {
        self.lblTime.text = @"";
    }
    else {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
        NSDate *date = [df dateFromString:timeStr];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        [df1 setDateFormat:@"hh:mm a"];
        timeStr = [df1 stringFromDate:date];
        self.lblTime.text = timeStr;
    }

    
    [self.imgDP sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[message objectForKey:@"image"]] ] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
    
    
}
@end
