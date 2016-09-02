//
//  ResultViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 16/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblRetake;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalScore;
@property (strong, nonatomic) IBOutlet UIView *vwLine;
-(IBAction)backButtonClick:(id)sender;
-(IBAction)RetakeTestClick:(id)sender;
-(IBAction)ContinueButtonClick:(id)sender;



@property (strong, nonatomic) NSString *strScore;
@end
