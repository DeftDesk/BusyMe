//
//  ChatSenderCell.m
//  Top10
//
//  Created by Gill on 24/08/15.
//  Copyright (c) 2015 Gill. All rights reserved.
//

#import "ChatSenderCell.h"
#import "UIImageView+WebCache.h"

@implementation ChatSenderCell

- (void)awakeFromNib {
    // Initialization code
    self.imgSenderUser.layer.cornerRadius = self.imgSenderUser.frame.size.width / 2;
    self.imgSenderUser.clipsToBounds = YES;
    self.imgSenderUser.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.imgSenderUser.layer.borderWidth = 0.5;
    self.imgSenderUser.layer.masksToBounds = YES;
    self.imgSenderUser.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageText:(id)message {
    
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
        [df1 setDateFormat:@"dd MMM hh:mm a"];
        timeStr = [df1 stringFromDate:date];
        self.lblTime.text = timeStr;
    }
    
    
    NSString *messageStr = message[@"message"];
    
    CGSize constrainedSize = CGSizeMake(160, 9999);
    CGSize timedSize = CGSizeMake(160, 12);

    if ([UIScreen mainScreen].bounds.size.width > 375) {
        constrainedSize = CGSizeMake(240, 9999);
         timedSize = CGSizeMake(240, 12);

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
    
    
    if (size.width < 20) {
        size.width = 30;
    }
    self.bubbleWidth.constant = size.width + 45;
    self.bubbleHeight.constant = requiredFrame.size.height + 70;
    
//    self.bubbleWidth.constant = size.width + 25;
//    self.bubbleHeight.constant = size.height + 16;
//    
//    self.lblHeight.constant = size.height + 8;
    self.lblWidth.constant = requiredFrame.size.width + 5;
    
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        self.bubbleLeading.constant = self.frame.size.width - (size.width + 85);
        //self.lblLeading.constant = self.frame.size.width - (size.width + 66);
    }
    else if ([UIScreen mainScreen].bounds.size.width > 375)
    {
        self.bubbleLeading.constant = self.frame.size.width - (size.width - 03);
        //self.lblLeading.constant = self.frame.size.width - (size.width - 19);
    }
    else {
        self.bubbleLeading.constant = self.frame.size.width - (size.width + 32);
        //self.lblLeading.constant = self.frame.size.width - (size.width + 16);
    }
    
    [self layoutIfNeeded];
   
    if ([UIScreen mainScreen].bounds.size.width > 375)
    {
    self.bubbleImgVw.image = [[UIImage imageNamed:@"sender_bubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }else{
        self.bubbleImgVw.image = [[UIImage imageNamed:@"sender_bubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
    }
    self.lblMessage.text = message[@"message"];
    
    [self.imgSenderUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[message valueForKey:@"tourl"]]] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
    
//     NSString *timeStr = message[@"timestamp"];
//    if (timeStr == nil || timeStr == (id)[NSNull null]) {
//        self.lblTime.text = @"";
//        self.imgVwTick.hidden = true;
//    }
//    else {
//        self.imgVwTick.hidden = false;
//        NSDateFormatter *df = [[NSDateFormatter alloc]init];
//        [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
//        NSDate *date = [df dateFromString:timeStr];
//        
//        self.lblTime.text = [self differenceStringWithDate:date];
//    }
    
}

//get seconds, minutes, days AND Weeks from date
- (NSString *)differenceStringWithDate:(NSDate *)date{
    //NSDate* date = self;
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if (time < 60) {
        int diff = round(time);
        if (diff == 1)
            return @"1s";
        return [NSString stringWithFormat:@"%ds", diff];
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return @"1m";
        return [NSString stringWithFormat:@"%dm", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return @"1h";
        return [NSString stringWithFormat:@"%dh", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return @"1d";
        if (diff == 7)
            return @"1w";
        return[NSString stringWithFormat:@"%dd", diff];
    } else {
        int diff = round(time / 60 / 60 / 24 / 7);
        if (diff == 1)
            return @"1w";
        return [NSString stringWithFormat:@"%dw", diff];
    }
}


@end
