//
//  ExamTableViewCell.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnSelectAns1;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAns2;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAns3;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAns4;

@property (strong, nonatomic) IBOutlet UIImageView *imgBtn1;
@property (strong, nonatomic) IBOutlet UIImageView *imgBtn2;
@property (strong, nonatomic) IBOutlet UIImageView *imgBtn3;
@property (strong, nonatomic) IBOutlet UIImageView *imgBtn4;


@property (strong, nonatomic) IBOutlet UILabel *lblAns1;
@property (strong, nonatomic) IBOutlet UILabel *lblAns2;
@property (strong, nonatomic) IBOutlet UILabel *lblAns3;
@property (strong, nonatomic) IBOutlet UILabel *lblAns4;


@property (strong, nonatomic) IBOutlet UILabel *lblA;
@property (strong, nonatomic) IBOutlet UILabel *lblB;
@property (strong, nonatomic) IBOutlet UILabel *lblC;
@property (strong, nonatomic) IBOutlet UILabel *lblD;



@end
