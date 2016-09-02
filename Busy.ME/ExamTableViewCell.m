//
//  ExamTableViewCell.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ExamTableViewCell.h"

@implementation ExamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblA.layer.cornerRadius = self.lblA.frame.size.width / 2;
    self.lblA.layer.masksToBounds = YES;
    
    self.lblB.layer.cornerRadius = self.lblB.frame.size.width / 2;
    self.lblB.layer.masksToBounds = YES;

    self.lblC.layer.cornerRadius = self.lblC.frame.size.width / 2;
    self.lblC.layer.masksToBounds = YES;

    self.lblD.layer.cornerRadius = self.lblD.frame.size.width / 2;
    self.lblD.layer.masksToBounds = YES;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
