//
//  ExamViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamTableViewCell.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vwTbl.layer.borderWidth = 2.0f;
    self.vwTbl.layer.borderColor =[UIColor grayColor].CGColor;

    
//    arrayAnswer =[[NSArray alloc]initWithObjects:@"India",@"Australia",@"Canada",@"England", nil];
    
   
    selectSection = -1;
    selectBtn = -1;
    
    arrayAnswer =[[NSMutableArray alloc]init];

    for (int i =0; i<5; i++)
    {
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
        [mutableDict setObject:@"India" forKey:@"Key1"];
        [mutableDict setObject:@"Australia" forKey:@"Key2"];
        [mutableDict setObject:@"Canada" forKey:@"Key3"];
        [mutableDict setObject:@"England" forKey:@"Key4"];
        [arrayAnswer addObject:mutableDict];
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"ExamTableViewCell" bundle:nil];
    [self.tblVW registerNib:cellNib forCellReuseIdentifier:@"ExamTableViewCell"];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ExamTableViewCell";
    
    ExamTableViewCell *cell = (ExamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == selectSection)
    {
        
            if (cell.btnSelectAns1.tag == selectBtn)
            {
                [cell.btnSelectAns1 setSelected:YES];
                [cell.btnSelectAns2 setSelected:NO];
                [cell.btnSelectAns3 setSelected:NO];
                [cell.btnSelectAns4 setSelected:NO];
            }
            else if (cell.btnSelectAns2.tag == selectBtn)
            {
                [cell.btnSelectAns1 setSelected:NO];
                [cell.btnSelectAns2 setSelected:YES];
                [cell.btnSelectAns3 setSelected:NO];
                [cell.btnSelectAns4 setSelected:NO];
            }
            else if (cell.btnSelectAns3.tag == selectBtn)
            {
                [cell.btnSelectAns1 setSelected:NO];
                [cell.btnSelectAns2 setSelected:NO];
                [cell.btnSelectAns3 setSelected:YES];
                [cell.btnSelectAns4 setSelected:NO];
            }
            else {
                [cell.btnSelectAns1 setSelected:NO];
                [cell.btnSelectAns2 setSelected:NO];
                [cell.btnSelectAns3 setSelected:NO];
                [cell.btnSelectAns4 setSelected:YES];
            }
    }
       cell.lblAns1.text = arrayAnswer[indexPath.row][@"Key1"];
    cell.lblAns2.text = arrayAnswer[indexPath.row][@"Key2"];
    cell.lblAns3.text = arrayAnswer[indexPath.row][@"Key3"];
    cell.lblAns4.text = arrayAnswer[indexPath.row][@"Key4"];
    
    if (indexPath.section ==0)
    {
        cell.btnSelectAns1.tag = indexPath.row+1;
        cell.btnSelectAns2.tag = indexPath.row+2;
        cell.btnSelectAns3.tag = indexPath.row+3;
        cell.btnSelectAns4.tag = indexPath.row+4;
    }else{
        cell.btnSelectAns1.tag = (indexPath.section*4+1);
        cell.btnSelectAns2.tag = (indexPath.section*4+2);
        cell.btnSelectAns3.tag = (indexPath.section*4+3);
        cell.btnSelectAns4.tag = (indexPath.section*4+4);
    }
   
    
    [cell.btnSelectAns1 addTarget:self action:@selector(selectAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectAns2 addTarget:self action:@selector(selectAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectAns3 addTarget:self action:@selector(selectAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectAns4 addTarget:self action:@selector(selectAnswerButton:) forControlEvents:UIControlEventTouchUpInside];


    
   // cell.textLabel.text = @"test";
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tblVW.frame.size.width,44)];
    sectionView.backgroundColor = [UIColor clearColor];
    sectionView.tag=section;
    
    UILabel *lblQuestion=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,30, 40)];
    lblQuestion.backgroundColor=[UIColor clearColor];
    lblQuestion.textColor =[UIColor blackColor];
    lblQuestion.textAlignment = NSTextAlignmentRight;
    lblQuestion.text =[NSString stringWithFormat:@"Q%ld",(long)section+1];
    lblQuestion.font =[UIFont systemFontOfSize:18.0f];
    
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.tblVW.frame.size.width-80, 40)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textAlignment = NSTextAlignmentLeft;

  //  viewLabel.text=[NSString stringWithFormat:@"%@",[[self.arrayData valueForKey:@"table_name"]objectAtIndex:section]];
    
   
    viewLabel.textColor = [UIColor blackColor];
    viewLabel.numberOfLines =2;
    viewLabel.text = @"What is your favorite country?";
    viewLabel.font =[UIFont systemFontOfSize:12.0f];

    [sectionView addSubview:lblQuestion];
    
    [sectionView addSubview:viewLabel];
    
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39, self.tblVW.frame.size.width-15, 1)];
    separatorLineView.backgroundColor = [UIColor blackColor];
    //[sectionView addSubview:separatorLineView];
    
    return  sectionView;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tblVW)
    { UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
#pragma mark
#pragma mark UIButton Methods
#pragma mark

-(void)selectAnswerButton:(id)sender{
   
    UIButton *button=(UIButton*)sender;

    
    NSLog(@"Button tag: %ld", (long)button.tag);

    NSLog(@"Button pressed: %ld", (long)button.tag/4);

    
//    ExamTableViewCell *buttonCell = (ExamTableViewCell *)[senderButton superview];
//    NSIndexPath* pathOfTheCell = [self.tblVW indexPathForCell:buttonCell];
//    
//    NSInteger rowOfTheCell = [pathOfTheCell row];
    
    NSLog(@"%ld",button.tag%4);
    
        selectSection = button.tag/4;
        selectBtn = button.tag;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblVW];
    NSIndexPath *indexPath = [self.tblVW indexPathForRowAtPoint:buttonPosition];
    selectSection= indexPath.section;
    if (indexPath != nil)
    {
        [self.tblVW reloadData];

    }
    
    
}
@end
