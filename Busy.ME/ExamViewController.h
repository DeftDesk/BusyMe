//
//  ExamViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *arrayAnswer;
    NSInteger selectSection,selectBtn;
}
@property (strong, nonatomic) IBOutlet UITableView *tblVW;
@property (strong, nonatomic) IBOutlet UIView *vwTbl;
@property (nonatomic, assign) NSInteger lastVlaue;

@end
