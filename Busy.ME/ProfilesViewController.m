//
//  ProfilesViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 18/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ProfilesViewController.h"
#import "ProfileCollectionViewCell.h"
#import "SingleTonClasses.h"
#import "IndustriesViewController.h"
#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
#import "OpenProfileVC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "FriendsProfileVC.h"


@interface ProfilesViewController ()<APIMasterDelegate>

@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;
    self.vwColl.layer.borderWidth = 2.0f;
    self.vwColl.layer.borderColor =[UIColor grayColor].CGColor;

    strMarkConnect =@"1";
    [self.collectionVW registerNib:[UINib nibWithNibName:@"ProfileCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    int cellWidth ;
    CGFloat spacing = 10; // the amount of spacing to appear between image and title
    
    
    if ([UIScreen mainScreen].bounds.size.width == 375)
    {
        cellWidth =  ([UIScreen mainScreen].bounds.size.width/2);
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [flowLayout setItemSize:CGSizeMake(cellWidth+4.5,cellWidth)];
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        cellWidth = (self.view.frame.size.width/2);
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayout setItemSize:CGSizeMake(cellWidth+3.75,cellWidth)];
        
    }else{
        cellWidth =  ([UIScreen mainScreen].bounds.size.width/2);
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [flowLayout setItemSize:CGSizeMake(cellWidth,cellWidth)];
    }
    
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setItemSize:CGSizeMake(cellWidth-30,cellWidth+40)];

    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionVW.backgroundColor = [UIColor whiteColor];
    
    [self.collectionVW setCollectionViewLayout:flowLayout];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *dictPosition =[NSDictionary dictionaryWithDictionary:[CommonMethods getDictWithKey:kUserPosition]];
    NSArray *arr =[dictPosition objectForKey:@"values"];
    NSLog(@"%@ at %@",arr[0][@"title"],arr[0][@"company"][@"name"]);
    
    totalConnected = 0;
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getUserDefaults];
    NSArray *arryConnects =[[NSArray alloc]initWithArray:data.contactsDict];
    if ([arryConnects [0] valueForKey:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No User Available In Specified Category"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        arrayConnects =[[NSMutableArray alloc]init];
        for (int i =0; i < arryConnects.count; i++)
        {
            if ([arryConnects[i][@"connected"]integerValue] == 1)
            {
                totalConnected = totalConnected +1;
            }
            [arrayConnects addObject:arryConnects[i]];
        }
        [self.collectionVW reloadData];
    }
    NSLog(@"%d",totalConnected);
}
-(IBAction)profileBackButton:(id)sender{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int i = 0; i < [viewControllers count]; i++){
        id obj = [viewControllers objectAtIndex:i];
        if ([obj isKindOfClass:[IndustriesViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }

}

#pragma mark
#pragma mark UIAlertView Delegate Methods
#pragma mark

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark
#pragma mark <UICollectionViewDataSource>
#pragma mark

// Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayConnects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setTextOnCell:arrayConnects[indexPath.row]];
   
    if ([arrayConnects[indexPath.row][@"connected"]integerValue] == 1)
    {
        [cell.btnConnect setSelected:YES];
    }
    else{
        [cell.btnConnect setSelected:NO];
    }
    cell.btnConnect.tag = indexPath.row+1;
    [cell.btnConnect addTarget:self action:@selector(connectUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

#pragma mark
#pragma mark <UICollectionViewDelegate>
#pragma mark

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
       //open_profile
   
    FriendsProfileVC *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"friends_view"];
    profile.strFrndsUserId =[NSString stringWithFormat:@"%@",arrayConnects[indexPath.row][@"userid"]];
    [self.navigationController pushViewController:profile animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 05;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark
#pragma mark <UIButton Methods>
#pragma mark

-(void)connectUserButtonClicked:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%ld",btn.tag -1);
    NSLog(@"%@",arrayConnects[btn.tag-1]);
    
    if (totalConnected == 6)
    {
        UIAlertView *askToPurchase = [[UIAlertView alloc]
                                      initWithTitle:@"Message"
                                      message:@"Do you want to remove ads for $0.99 ?"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Yes", @"No", nil];
        askToPurchase.delegate = self;
        askToPurchase.tag = 111;
        [askToPurchase show];
  
    }else{
        lastIndex = btn.tag-1;
        dictConnect =[[NSMutableDictionary alloc]initWithDictionary:arrayConnects[btn.tag-1]];
        
        [dictConnect removeObjectForKey:@"connected"];
        
        if (!btn.isSelected)
        {
            [dictConnect setObject:@"1" forKey:@"connected"];
        }
        else{
            [dictConnect setObject:@"0" forKey:@"connected"];
        }
        
        
        [self sendRequestToWeb];
    }
    
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 111)
    {
        if (buttonIndex==0) {
            // user tapped YES, but we need to check if IAP is enabled or not.
            if ([SKPaymentQueue canMakePayments]) {
                
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"purchaseApp"]];
                
                request.delegate = self;
                [request start];
                
                
            } else {
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:@"Prohibited"
                                    message:@"Parental Control is enabled, cannot make a purchase!"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil];
                [tmp show];
                
            }
        }
    }
    
}
#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                // show wait view here
                // self.navigationController.title = @"Processing...";
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([transaction.payment.productIdentifier isEqualToString:@"puchaseApp"]) {
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AdsRemoved"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                    
                });
                
                
                
                // remove wait view and unlock feature 2
                //self.navigationController.title  = @"Done!";
                
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:@"Complete"
                                    message:@"You have Removed Ads"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil];
                [tmp show];
                
                
                
                
                // do other thing to enable the features
                
                break;
                
                
                
        }
    }
}



-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    // remove wait view here
    
    
    SKProduct *validProduct = nil;
    int count = [response.products count];
    
    if (count==0) {
        // validProduct = [response.products objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"purchaseApp"];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
        
    }
    
    
}

-(void)requestDidFinish:(SKRequest *)request
{
    
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
}



#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=markconnected&userid=%@&Otheruserd=%@&Status=%@",[CommonMethods accessUserDefaultsWithKey:kUserId],[dictConnect objectForKey:@"userid"],[dictConnect objectForKey:@"connected"]]];
    
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
        if ([[response objectForKey:@"status"]boolValue])
        {
            NSArray *arr =[response objectForKey:@"data"];
            
            [arrayConnects replaceObjectAtIndex:lastIndex withObject:dictConnect];
            
            SingleTonClasses *data = [SingleTonClasses sharedManager];
            data.contactsDict = [[NSArray alloc]initWithArray:arrayConnects];
            [data saveUserDefaults];
            
            [self.collectionVW performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self viewWillAppear:true];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                message:arr[0][@"Message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
        }
    
}



@end
