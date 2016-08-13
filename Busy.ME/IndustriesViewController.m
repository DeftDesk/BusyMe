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

@interface IndustriesViewController ()

@end

@implementation IndustriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewtbl.layer.borderWidth = 2.0f;
    self.viewtbl.layer.borderColor =[UIColor grayColor].CGColor;

    arrayIndustries =[[NSArray alloc]initWithObjects:@"business",@"technology",@"web design",@"web development",@"marketing",@"seo",@"graphic design",@"video creation",@"animation", nil];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
    {
        self.tblView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"IndustriesTableViewCell" bundle:nil];
    [self.tblView registerNib:cellNib forCellReuseIdentifier:@"IndustriesTableViewCell"];
    selectedIndex = -1;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.lblName.text =[NSString stringWithFormat:@"%@",[arrayIndustries[indexPath.row] capitalizedString]];
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
@end
