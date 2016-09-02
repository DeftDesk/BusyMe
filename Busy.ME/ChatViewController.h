//
//  ChatViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSInteger lastIndex;

}
@property (strong, nonatomic) IBOutlet UITableView *tblChat;
@property (strong, nonatomic) NSString *strFrndId;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end
