//
//  ProfilesViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 18/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface ProfilesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,UIAlertViewDelegate,SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSMutableArray *arrayConnects;
    NSMutableDictionary *dictConnect;
    NSInteger lastIndex;
    NSString *strMarkConnect;
    int totalConnected;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionVW;
@property (strong, nonatomic) IBOutlet UIView *vwColl;

-(IBAction)profileBackButton:(id)sender;

@end
