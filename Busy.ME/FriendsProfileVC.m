//
//  FriendsProfileVC.m
//  Busy.ME
//
//  Created by Deft Desk on 25/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "FriendsProfileVC.h"
#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserProfileCell.h"
#import "ChatViewController.h"
#import "OpenChatVC.h"

@interface FriendsProfileVC ()<APIMasterDelegate,OpenChatVCDelegate>

@end
#define kTagContactImg          6789
#define kTagContactName         6790
@implementation FriendsProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.txtInterst.layer.cornerRadius  = 3.0f;
    self.txtInterst.layer.borderWidth = 1.0f;
    
    self.txtInterst.layer.borderColor = [UIColor grayColor].CGColor;
    [self.txtInterst setClipsToBounds:YES];
    
    self.btnSendMsg.layer.cornerRadius = 8.0f;
    [self.btnSendMsg setClipsToBounds:YES];

    [self.btnDropDown addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.txtInterst.leftView = paddingView;
    self.txtInterst.leftViewMode = UITextFieldViewModeAlways;
    
    UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc] init];
    
        
        layout1.minimumLineSpacing =0;
        
        contactCollection=[[UICollectionView alloc] initWithFrame:self.lblNoConnects.frame collectionViewLayout:layout1];
        [contactCollection setDataSource:self];
        [contactCollection setDelegate:self];
        [layout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [contactCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [contactCollection setBackgroundColor:[UIColor clearColor]];
    contactCollection.hidden = YES;
    [self.vwSub addSubview:contactCollection];
    [self.lblNoConnects setHidden:NO];
    self.txtInterst.enabled = YES;
    self.txtDesignation.enabled = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"my id =%@, frnd id=%@",[CommonMethods accessUserDefaultsWithKey:kUserId],self.strFrndsUserId);
    
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getInterestDefaults];
    NSArray *array = [[NSArray alloc]initWithArray:data.interstArray];
    if([[array objectAtIndex:0] valueForKey:@"Message"] != nil) {
        // The key existed...
        NSLog(@"%@",array[0]);
        
    }
    else {
        // No joy...
        NSLog(@"%@",array[0]);
        arrayCat =[[NSMutableArray alloc]initWithArray:array];
    }
    
    
    
    [self sendRequestToWeb];
}

#pragma mark
#pragma mark UIButton Methods
#pragma mark

-(IBAction)FriendProfileBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)dropDownButtonClick:(id)sender
{
    if (!self.btnDropDown.isSelected)
    {
        [self.btnDropDown setSelected:YES];
        
    }else{
        
        [self.btnDropDown setSelected:NO];
    }
    
    
}
-(IBAction)SendMessageButtonClick:(id)sender{
   
    if ([CommonMethods accessUserDefaultsWithKey:kUserId] == self.strFrndsUserId)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"You can't message to yourself."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
 
    }
    OpenChatVC *exam =[self.storyboard instantiateViewControllerWithIdentifier:@"open_chat"];
    exam.delegate = self;
    exam.strSenderName = [[[dictFrndData objectForKey:@"userprofile"]objectAtIndex:0]valueForKey:@"name"];
    exam.strFriendUserId =self.strFrndsUserId;;
    [self.navigationController pushViewController:exam animated:true];
}
#pragma mark
#pragma mark OpenChatDelegate Methods
#pragma mark
-(void)updateLastMessageWithinputString:(NSString *)message
{
    
}
#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=get_all_info_byuser&userid=%@",self.strFrndsUserId]];
    
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([[response objectForKey:@"status"]boolValue])
    {
        if ([[response allKeys] containsObject:@"data"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"No User Available."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        else{
            [self performSelectorOnMainThread:@selector(updateUserData:) withObject:response waitUntilDone:NO];
        }
        
    }
    
}

-(void)updateUserData:(id)dict{
    
    NSArray *arrProfile =[dict objectForKey:@"userprofile"];
    //    NSLog(@"%@",arrProfile[0]);
    NSArray *arrConnects =[dict objectForKey:@"connect"];
    //    NSLog(@"%@",arrConnects[0]);
    dictFrndData = [NSDictionary dictionaryWithDictionary:dict];
    if (arrConnects.count > 0)
    {
        [self.lblNoConnects setHidden:YES];
        [contactCollection setHidden:NO];
        arrayConnects = [[NSMutableArray alloc]initWithArray:arrConnects];
        [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }else{
        [self.lblNoConnects setHidden:NO];
        self.lblNoConnects.text  = @"NO CONNECTS";
        [contactCollection setHidden:YES];
        [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    }
    self.lblFrndsname.text = [[arrProfile[0] valueForKey:@"name"]capitalizedString];
    self.lblFrndsDesiganation.text = [[arrProfile[0] valueForKey:@"designation"]capitalizedString];
    self.txtDesignation.text = [[arrProfile[0] valueForKey:@"designation"]capitalizedString];
    
    [self.imgFrnds sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrProfile[0]valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholderBig"]];
    
    if ([[arrProfile[0] valueForKey:@"isactive"]integerValue] == 1)
    {
        [self.imgOnline setHidden:NO];
    }
    else{
        [self.imgOnline setHidden:YES];
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
    
        UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *conatctImg = (UIImageView*)[cell.contentView viewWithTag:kTagContactImg];
        UILabel *contactName  = (UILabel*)[cell.contentView viewWithTag:kTagContactName];
        
        if (conatctImg == nil)
        {
            //        conatctImg= [[UIImageView alloc]initWithFrame:CGRectMake(WidthOFRect(cell)/2-25,5,75,75)];
            conatctImg= [[UIImageView alloc]initWithFrame:CGRectMake(WidthOFRect(cell)/2-40,5,80,80)];
            NSLog(@"%f",WidthOFRect(cell)/2-45);
            conatctImg.contentMode = UIViewContentModeScaleToFill;
            conatctImg.layer.cornerRadius = WidthOFRect(conatctImg)/2;
            conatctImg.clipsToBounds = YES;
            conatctImg.backgroundColor = [UIColor clearColor];
            conatctImg.tag = kTagContactImg;
            conatctImg.image = [UIImage imageNamed:@"userPlaceHolder"];
            [cell.contentView addSubview:conatctImg];
            
            contactName = [[UILabel alloc]initWithFrame:CGRectMake(5, YOriginOfRect(conatctImg)+HeightOfRect(conatctImg)+5,WidthOFRect(cell)-10,20)];
            contactName.numberOfLines = 0;
            contactName.tag = kTagContactName;
            contactName.text = @"JEFF";
            contactName.textAlignment = NSTextAlignmentCenter;
            contactName.font = [UIFont fontWithName:@"Gotham-Book" size:11];
            contactName.textColor = [UIColor lightGrayColor];
            //[cell.contentView addSubview:contactName];
        }
        
        [conatctImg sd_setImageWithURL:[NSURL URLWithString:[[arrayConnects objectAtIndex:indexPath.row]objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
        contactName.text = @"test";
        
        return cell;
        
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(90,HeightOfRect(collectionView));
}

#pragma mark
#pragma mark <UICollectionViewDelegate>
#pragma mark

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark
#pragma mark <UITextFieldDelegate>
#pragma mark
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == self.txtInterst)
    {
        [self dropDownButtonClick:nil];
        return false;
    }
    return true;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtInterst)
    {
        //[self dropDownButtonClick:nil];
    }
    else if (textField == self.txtDesignation){
            }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
       
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    if (textField == self.txtInterst)
    {
        [arrayCat addObject:self.txtInterst.text];
    }
    
    if (textField == self.txtDesignation) {
        [self.txtDesignation resignFirstResponder];
    }
    
    return NO;
}


#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCat.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[arrayCat[indexPath.row][@"name"] capitalizedString]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.txtInterst.text = [NSString stringWithFormat:@"%@",arrayCat[indexPath.row][@"name"]];
    [self.btnDropDown setSelected:false];
    [_popViewFrnd dismissPopoverAnimatd:YES];
    [tableView reloadData];
    [tableView setContentOffset:CGPointZero animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
#pragma mark
#pragma mark UITSPopoverController Methods
#pragma mark
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake((self.view.frame.size.width-200)/2,0, 200, 300);
    tableViewController.tableView.delegate = self;
    tableViewController.tableView.dataSource = self;
    [tableViewController.tableView reloadData];

    
    _popViewFrnd = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    _popViewFrnd.cornerRadius = 5;
    _popViewFrnd.titleText = @"CHOOSE INTEREST";
    _popViewFrnd.popoverBaseColor = [UIColor colorWithRed:41/255.0f green:32/255.0f blue:76/255.0f alpha:1];
    _popViewFrnd.popoverGradient= NO;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [_popViewFrnd showPopoverWithTouch:event];
    
}

@end
