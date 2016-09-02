//
//  FriendsProfileVC.h
//  Busy.ME
//
//  Created by Deft Desk on 25/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPopoverController.h"
@interface FriendsProfileVC : UIViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UICollectionView *contactCollection;
    NSMutableArray *arrayConnects,*arrayCat;
    NSDictionary *dictFrndData;
}

@property (strong, nonatomic) IBOutlet UILabel *lblFrndsname;
@property (strong, nonatomic) IBOutlet UILabel *lblFrndsDesiganation;
@property (strong, nonatomic) IBOutlet UIImageView *imgFrnds;
@property (strong, nonatomic) IBOutlet UIImageView *imgOnline;
@property (strong, nonatomic) IBOutlet UILabel *lblNoConnects;
@property (strong, nonatomic) IBOutlet UITextField *txtDesignation;
@property (strong, nonatomic) IBOutlet UITextField *txtInterst;

@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;

@property (strong, nonatomic) IBOutlet UIButton *btnSendMsg;
@property (strong, nonatomic) IBOutlet UIButton *btnInterst;


@property (strong, nonatomic) IBOutlet UIView *vwSub;

-(IBAction)FriendProfileBackButton:(id)sender;
-(IBAction)SendMessageButtonClick:(id)sender;


@property (strong, nonatomic) NSString *strFrndsUserId;
@property (strong,nonatomic) TSPopoverController *popViewFrnd;


@end
