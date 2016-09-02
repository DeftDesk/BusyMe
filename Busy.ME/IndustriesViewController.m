//
//  IndustriesViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "IndustriesViewController.h"
#import "IndustriesTableViewCell.h"
#import "ExamViewController.h"
#import "ExamViewController.h"
#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
#import "SingleTonClasses.h"
#import "ConnectsVC.h"
#import "SettingsVC.h"

@interface IndustriesViewController ()<APIMasterDelegate>

@end

@implementation IndustriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.viewtbl.layer.borderWidth = 2.0f;
    self.viewtbl.layer.borderColor =[UIColor grayColor].CGColor;
    
    
   // arrayIndustries =[[NSArray alloc]initWithObjects:@"business",@"technology",@"web design",@"web development",@"marketing",@"seo",@"graphic design",@"video creation",@"animation", nil];
    NSLog(@"userid-%@",[CommonMethods accessUserDefaultsWithKey:kUserId]);
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
    {
        self.tblView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"IndustriesTableViewCell" bundle:nil];
    [self.tblView registerNib:cellNib forCellReuseIdentifier:@"IndustriesTableViewCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    selectedIndex = -1;
    [self.tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendRequestToWeb];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)connectsButton:(id)sender{
   // ConnectsVC *connect =[self.storyboard instantiateViewControllerWithIdentifier:@"connects_frnds"];
    
    SettingsVC *connect =[self.storyboard instantiateViewControllerWithIdentifier:@"setting_view"];

    [self.navigationController pushViewController:connect animated:YES];
}

#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayIndustries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *cellIdentifier = @"IndustriesTableViewCell";
    
     IndustriesTableViewCell *cell = (IndustriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == selectedIndex)
    {
        [cell.btnRadio setSelected:true];
        cell.lblName.textColor =[UIColor colorWithRed:0/255.0f green:211/255.0f blue:186/255.0f alpha:1.0];
    }
    else
    {
        [cell.btnRadio setSelected:false];
        cell.lblName.textColor =[UIColor blackColor];
    }
    
    cell.lblName.text =[NSString stringWithFormat:@"%@",[arrayIndustries[indexPath.row][@"name"] capitalizedString]];
    cell.btnRadio.tag = indexPath.row +1;
    [cell.btnRadio addTarget:self action:@selector(selectRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    selectedIndex = indexPath.row;
    [self.tblView reloadData];
    ExamViewController *exam =[self.storyboard instantiateViewControllerWithIdentifier:@"examVC"];
    exam.dictId = [NSDictionary dictionaryWithDictionary:arrayIndustries[indexPath.row]];
    [self.navigationController pushViewController:exam animated:true];
    
}
#pragma mark
#pragma mark UIButton Methods
#pragma mark

-(void)selectRadioButtonClick:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
   
    selectedIndex = btn.tag -1;
    [self.tblView reloadData];
    
//    if (!btn.isSelected)
//    {
//        [btn setSelected:true];
//    }else{
//        [btn setSelected:false];
//    }
    
}

#pragma mark
#pragma mark Custom Methods
#pragma mark
-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    
    //     NSString *postStr = [NSString stringWithFormat:@"userid=%@&promiseid=%@&promise_msg=%@&promise_end_date=%@&promise_end_time=%@&promise_made_to_id=%@&categoryid=%@&categoryname=%@",[CommonMethods accessUserDefaultsWithKey:kUserId],[self.promiseInfoDict objectForKey:@"prmise_id"],self.promiseTxtView.text,date,time,[self.promiseInfoDict valueForKey:@"promise_made_to_id"],[self.promiseInfoDict objectForKey:@"promise_category"],self.categoryTxtFld.text];
    
    [apimaster sendRequestToWebWithInputStr:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=all_available_category"];
    
    //    [apimaster sendRequestToWebWithInputStr:@"http://demo.cbtcomply.com/fshubservices/api/users/6035"];
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if ([[response objectForKey:@"status"]boolValue])
    {
        NSDictionary *dict = [response objectForKey:@"data"];
        
        if([dict isKindOfClass:[NSDictionary class]]){
            arrayIndustries = [[NSMutableArray alloc]init];

            for (int i =0; i < [dict allKeys].count; i++)
            {
                NSLog(@"%@",[dict objectForKey:[dict allKeys][i]]);
                
                
                [arrayIndustries addObject:[dict objectForKey:[dict allKeys][i]]];
                
            }
            
            if (arrayIndustries.count > 0)
            {
                SingleTonClasses *data = [SingleTonClasses sharedManager];
                data.interstArray = [[NSArray alloc]initWithArray:arrayIndustries];
                [data saveInterestDefaults];

            }
            
            [self.tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
            
        }
        else{
            NSArray *arr =[response objectForKey:@"data"];
            
            SingleTonClasses *data = [SingleTonClasses sharedManager];
            data.interstArray = [[NSArray alloc]initWithArray:arr];
            [data saveInterestDefaults];
            
            if ([arr[0][@"Message"] isEqualToString:@"No Category Available"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                message:arr[0][@"Message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }

        }
    }
    
}

@end
