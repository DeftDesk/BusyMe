//
//  ExamViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *arrayAnswer, *arraySelectedAns, *arrayData;
    NSInteger selectSection,selectBtn;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    int total;
}
@property (strong, nonatomic) IBOutlet UITableView *tblVW;
@property (strong, nonatomic) IBOutlet UIView *vwTbl;
@property (nonatomic, assign) NSInteger lastVlaue;
@property (strong, nonatomic) NSDictionary *dictId;
@property (strong, nonatomic) IBOutlet UILabel *progress;


@end
