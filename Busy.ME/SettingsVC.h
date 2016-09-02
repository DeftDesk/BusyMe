//
//  SettingsVC.h
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface SettingsVC : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *vw;
@property (strong, nonatomic) IBOutlet UIView *vwTbl;

-(IBAction)settingBack:(id)sender;
@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;

@end
