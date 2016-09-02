//
//  ConnectCell.m
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ConnectCell.h"

@implementation ConnectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewCell.layer.borderWidth = 0.4f;
    self.viewCell.layer.cornerRadius = 5.0f;
    self.viewCell.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.viewCell.clipsToBounds=YES;
}

@end
