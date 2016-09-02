//
//  ProfileCollectionViewCell.h
//  Busy.ME
//
//  Created by Deft Desk on 18/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UIButton *btnConnect;

-(void)setTextOnCell:(id)text;

@end
