//
//  SettingsVC.m
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingTableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"


@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self standardSlider];
    
    UINib *cellNib = [UINib nibWithNibName:@"SettingTableViewCell" bundle:nil];
    [self.tbl registerNib:cellNib forCellReuseIdentifier:@"SettingTableViewCell"];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.view respondsToSelector:@selector(setTintColor:)])
    {
        self.view.tintColor = [UIColor darkGrayColor];
    }
    
}

-(void)settingBack:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 6;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"SettingTableViewCell";
        
        SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        if (indexPath.row == 0)
        {
            [cell.imgIcons setImage:[UIImage imageNamed:@"takeTest"]];
            cell.lblName.text = @"Take Test";
        }else if (indexPath.row == 1)
        {
            [cell.imgIcons setImage:[UIImage imageNamed:@"moreConnects"]];
            cell.lblName.text = @"More Connects";
            
        }else if (indexPath.row == 2)
        {
            [cell.imgIcons setImage:[UIImage imageNamed:@"about"]];
            cell.lblName.text = @"About";
            
        }else if (indexPath.row == 3)
        {
            [cell.imgIcons setImage:[UIImage imageNamed:@"faq"]];
            cell.lblName.text = @"Faq";
        }
        else if (indexPath.row == 4)
        {
            [cell.imgIcons setImage:[UIImage imageNamed:@"report"]];
            cell.lblName.text = @"Report";
        }else if (indexPath.row == 5)
        {
            // cell.imageView.image = [UIImage imageNamed:@"logout"];
            cell.lblName.text = @"Logout";
            
            [cell.imgIcons setImage:[UIImage imageNamed:@"logout"]];
        }
        
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        return cell;
    }
    
    
    return nil;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0)
    {
         if (indexPath.row == 5)
        {
           UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Are you sure you want to log out"delegate:self
                             cancelButtonTitle:@"No"
                             otherButtonTitles:@"Yes", nil];
            alert.tag = 111;
            
            
            [alert show];
        }
    }
    
    
}
#pragma mark
#pragma mark UIAlertView Delegate Methods
#pragma mark

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1)
    {
        [CommonMethods initUserDefaults:@"0" andKey:kUserId];
        [CommonMethods initUserDefaults:@"0" andKey:kIsLogin];
        [CommonMethods removeUserDefaultsWithKey:kUserPosition];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
        [[AppDelegate shareDelegates] getRootNavigationController];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return 0.001;
    }
    return 280;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }else{
       /* UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tbl.frame.size.width,280)];
        sectionView.backgroundColor = [UIColor redColor];
        sectionView.tag=section;
        sectionView.userInteractionEnabled = YES;
        self.vwTbl.userInteractionEnabled = YES;

        [sectionView addSubview:self.vwTbl];
        [sectionView bringSubviewToFront:self.vwTbl];
        
        return  sectionView;*/
        
        if (self.headerView == nil) {
            self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 280)];
        }
        self.headerView.backgroundColor = [UIColor whiteColor];
        self.vwTbl.frame = self.headerView.bounds;
        self.vwTbl.hidden = false;
        [self.headerView addSubview:self.vwTbl];
        self.vwTbl.userInteractionEnabled = true;
        
        return self.headerView;

 
    }
    
    
    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    
    return true;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (tableView == self.tblVW)
//    { UIView *headerView = [[UIView alloc] init];
//        headerView.backgroundColor = [UIColor clearColor];
//        return headerView;
//
//    }
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        return 0.001;
}

#pragma mark -
#pragma mark - Standard Slider


- (void) configureStandardSlider
{
    self.standardSlider.lowerValue = 0.23;
    self.standardSlider.upperValue = 0.53;
    self.standardSlider.tintColor = [UIColor redColor];
}
@end
