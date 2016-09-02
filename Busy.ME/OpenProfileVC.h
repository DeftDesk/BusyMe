//
//  OpenProfileVC.h
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPopoverController.h"

@interface OpenProfileVC : UIViewController<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UICollectionView *contactCollection;
    NSMutableArray *arrayConnects,*arrayCat, *arrayUploadImages;
    NSInteger lastTag;
    BOOL isBigImage, isClicked;
    NSDictionary *userDict;
    NSString *lastDesignation;
}
@property (strong, nonatomic) NSMutableArray *imagesArray;

@property (retain, nonatomic) UIImageView *overlayImageView;
@property (nonatomic) CGRect frameRect;


@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblUserDesiganation;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIImageView *imgOnline;
@property (strong, nonatomic) IBOutlet UILabel *lblNoConnects;
@property (strong, nonatomic) IBOutlet UITextField *txtDesignation;
@property (strong, nonatomic) IBOutlet UITextField *txtInterst;

@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;

@property (strong, nonatomic) IBOutlet UIButton *btnDesig;
@property (strong, nonatomic) IBOutlet UIButton *btnInterst;


@property (strong, nonatomic) IBOutlet UIView *vwSub;

-(IBAction)OpnProfileBackButton:(id)sender;
-(IBAction)designationButtonClick:(id)sender;
-(IBAction)interstButtonClick:(id)sender;
-(IBAction)dropDownButtonClick:(id)sender;
-(IBAction)updateProfileButtonClick:(id)sender;

-(IBAction)settingButtonClick:(id)sender;

@property (strong, nonatomic) NSString *strUserId;
@property (strong,nonatomic) TSPopoverController *popView;

@end
