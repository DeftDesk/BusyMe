//
//  IndustriesViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndustriesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrayIndustries;
    NSInteger selectedIndex;
}

@property (strong, nonatomic) IBOutlet UIView *viewtbl;
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
