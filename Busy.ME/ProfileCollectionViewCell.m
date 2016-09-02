//
//  ProfileCollectionViewCell.m
//  Busy.ME
//
//  Created by Deft Desk on 18/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ProfileCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation ProfileCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.btnConnect.layer.borderWidth = 1.0f;
//    self.btnConnect.layer.cornerRadius = 15.0f;
//    [self.btnConnect setClipsToBounds:YES];
//    self.btnConnect.layer.borderColor =[UIColor colorWithRed:41/255.0f green:32/255.0f blue:76/255.0f alpha:1].CGColor;
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height/2;
    self.imgUser.clipsToBounds = YES;
    self.imgUser.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imgUser.layer.borderWidth = 2.0f;

}

-(void)setTextOnCell:(id)text{
    self.lblName.text = [text[@"name"]capitalizedString];
    self.lblName.adjustsFontSizeToFitWidth = YES;
    self.lblPosition.text =[text[@"designation"]capitalizedString];
    self.lblPosition.adjustsFontSizeToFitWidth = YES;

    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:text[@"image"]] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
//    [self.lblName sizeToFit];
}


@end
