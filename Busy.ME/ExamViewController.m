//
//  ExamViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamTableViewCell.h"
#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
@interface ExamViewController ()<APIMasterDelegate>

@end

typedef NS_ENUM(NSInteger, kActionType)
{
    kActionTypeTotalScore,
    kActionTypeGetExam
};
kActionType actionTypePostScore;

@implementation ExamViewController
@synthesize progress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vwTbl.layer.borderWidth = 2.0f;
    self.vwTbl.layer.borderColor =[UIColor grayColor].CGColor;
    
    progress.textColor=[UIColor redColor];
    [progress setText:@"Time : 1:00"];
    progress.backgroundColor=[UIColor clearColor];
    [self.view addSubview:progress];
    currMinute=1;
    currSeconds=00;
//    arrayAnswer =[[NSArray alloc]initWithObjects:@"India",@"Australia",@"Canada",@"England", nil];
    
   
    selectSection = -1;
    selectBtn = -1;
    

//    for (int i =0; i<5; i++)
//    {
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"India" forKey:@"Key1"];
//        [mutableDict setObject:@"Australia" forKey:@"Key2"];
//        [mutableDict setObject:@"Canada" forKey:@"Key3"];
//        [mutableDict setObject:@"England" forKey:@"Key4"];
//        [arrayAnswer addObject:mutableDict];
//    }
    
    UINib *cellNib = [UINib nibWithNibName:@"ExamTableViewCell" bundle:nil];
    [self.tblVW registerNib:cellNib forCellReuseIdentifier:@"ExamTableViewCell"];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [progress setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [progress setText:@"Time Out"];
        [timer invalidate];
        [self calculateExamScore];
    }
}

-(void)calculateExamScore{

    total = 0;
    
    for (int i=0; i< arrayData.count; i++)
    {
        if ([arrayAnswer[i] isEqualToString:arrayData[i][@"correctans"]])
        {
            total = total+1;
        }
    }
    [CommonMethods initUserDefaults:@"1" andKey:kIsExam];

        actionTypePostScore = kActionTypeTotalScore;
        [self sendRequestToWeb];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    actionTypePostScore = kActionTypeGetExam;
    [self sendRequestToWeb];
}
#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (actionTypePostScore == kActionTypeTotalScore)
    {
        [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=addscore&userid=%@&catid=%@&Score=%d",[CommonMethods accessUserDefaultsWithKey:kUserId],[self.dictId objectForKey:@"id"],total]];

    }else{
        [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=question_by_category&catid=%@",[self.dictId objectForKey:@"id"]]];
    }
    
    
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (actionTypePostScore == kActionTypeTotalScore)
    {
        if ([[response objectForKey:@"status"]boolValue])
        {
            SingleTonClasses *data = [SingleTonClasses sharedManager];

            if([[response objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict =[[ NSDictionary alloc]initWithDictionary:[response objectForKey:@"data"]];
                
                NSMutableArray *array =[[NSMutableArray alloc]init];
                for (int i =1; i<=[dict allKeys].count; i++)
                {
                    [array addObject:[dict objectForKey:[dict allKeys][i-1]]];
                }
                data.contactsDict = [[NSArray alloc]initWithArray:array];
                [data saveUserDefaults];
                
            }else{
                NSArray *arr =[response objectForKey:@"data"];
                data.contactsDict = [[NSArray alloc]initWithArray:arr];
                [data saveUserDefaults];
                /*if ([arr[0][@"Message"] isEqualToString:@"No User Available In Specified Category"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                    message:arr[0][@"Message"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                }*/
                

            }
            ResultViewController *result =[self.storyboard instantiateViewControllerWithIdentifier:@"result_view"];
            
            result.strScore =[NSString stringWithFormat:@"%d/%lu",total,(unsigned long)arrayData.count];
            
            [self.navigationController pushViewController:result animated:YES];
        }
       
    }
    else
    {
   
        if ([[response objectForKey:@"status"]boolValue])
        {
        NSDictionary *dict = [response objectForKey:@"data"];
            
                if([dict isKindOfClass:[NSDictionary class]]){
                    
                    arrayData = [[NSMutableArray alloc]init];
                    arraySelectedAns =[[NSMutableArray alloc]init];
                    arrayAnswer =[[NSMutableArray alloc]init];
                    
                    for (int i =0; i < [dict allKeys].count; i++)
                    {
                        NSLog(@"%@",[dict objectForKey:[dict allKeys][i]]);
                        
                        [arrayData addObject:[dict objectForKey:[dict allKeys][i]]];
                        [arraySelectedAns addObject:@""];
                        [arrayAnswer addObject:@""];
                        
                    }
                    
                    if (arrayData.count > 0)
                    {
                        [self start];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                        message:@"No Questions Available"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];

                    }
                    [self.tblVW performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
                    
                }else{
                    NSArray *arr =[response objectForKey:@"data"];
                    if ([arr[0][@"Message"] isEqualToString:@"No Questions Available"])
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
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ExamTableViewCell";
    
    ExamTableViewCell *cell = (ExamTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblAns1.text = arrayData[indexPath.row][@"ansa"];
    cell.lblAns2.text = arrayData[indexPath.row][@"ansb"];
    cell.lblAns3.text = arrayData[indexPath.row][@"ansc"];
    cell.lblAns4.text = arrayData[indexPath.row][@"ansd"];
    
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
   
    if (cell.btnSelectAns1.tag == [arraySelectedAns[indexPath.section] integerValue])
    {
        [cell.btnSelectAns1 setSelected:YES];
        cell.imgBtn1.image = [UIImage imageNamed:@"selectRadioBtn"];
        cell.imgBtn2.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn3.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn4.image = [UIImage imageNamed:@"unSelectRadioBtn"];

        [cell.btnSelectAns2 setSelected:NO];
        [cell.btnSelectAns3 setSelected:NO];
        [cell.btnSelectAns4 setSelected:NO];
        [arrayAnswer replaceObjectAtIndex:indexPath.section withObject:@"ansa"];
    }
    else if (cell.btnSelectAns2.tag == [arraySelectedAns[indexPath.section] integerValue])
    {
        [cell.btnSelectAns1 setSelected:NO];
        [cell.btnSelectAns2 setSelected:YES];
        [cell.btnSelectAns3 setSelected:NO];
        [cell.btnSelectAns4 setSelected:NO];
        cell.imgBtn2.image = [UIImage imageNamed:@"selectRadioBtn"];
        cell.imgBtn1.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn3.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn4.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        [arrayAnswer replaceObjectAtIndex:indexPath.section withObject:@"ansb"];

    }
    else if (cell.btnSelectAns3.tag == [arraySelectedAns[indexPath.section] integerValue])
    {
        [cell.btnSelectAns1 setSelected:NO];
        [cell.btnSelectAns2 setSelected:NO];
        [cell.btnSelectAns3 setSelected:YES];
        [cell.btnSelectAns4 setSelected:NO];
        cell.imgBtn3.image = [UIImage imageNamed:@"selectRadioBtn"];
        cell.imgBtn2.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn1.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn4.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        [arrayAnswer replaceObjectAtIndex:indexPath.section withObject:@"ansc"];

    }
    else  if (cell.btnSelectAns4.tag == [arraySelectedAns[indexPath.section] integerValue]){
        [cell.btnSelectAns1 setSelected:NO];
        [cell.btnSelectAns2 setSelected:NO];
        [cell.btnSelectAns3 setSelected:NO];
        [cell.btnSelectAns4 setSelected:YES];
        cell.imgBtn4.image = [UIImage imageNamed:@"selectRadioBtn"];
        cell.imgBtn2.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn3.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn1.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        [arrayAnswer replaceObjectAtIndex:indexPath.section withObject:@"ansd"];

    }
    else {
        [cell.btnSelectAns1 setSelected:NO];
        [cell.btnSelectAns2 setSelected:NO];
        [cell.btnSelectAns3 setSelected:NO];
        [cell.btnSelectAns4 setSelected:NO];
        cell.imgBtn1.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn2.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn3.image = [UIImage imageNamed:@"unSelectRadioBtn"];
        cell.imgBtn4.image = [UIImage imageNamed:@"unSelectRadioBtn"];
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
        
        UILabel *lblQuestion=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,40, 40)];
        lblQuestion.backgroundColor=[UIColor clearColor];
        lblQuestion.textColor =[UIColor blackColor];
        lblQuestion.textAlignment = NSTextAlignmentCenter;
        lblQuestion.text =[NSString stringWithFormat:@"Q%ld",(long)section+1];
        lblQuestion.font =[UIFont systemFontOfSize:16.0f];
        
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.tblVW.frame.size.width-80, 40)];
        viewLabel.backgroundColor=[UIColor clearColor];
        viewLabel.textAlignment = NSTextAlignmentLeft;
        
        //  viewLabel.text=[NSString stringWithFormat:@"%@",[[self.arrayData valueForKey:@"table_name"]objectAtIndex:section]];
        
        
        viewLabel.textColor = [UIColor blackColor];
        viewLabel.numberOfLines =2;
        viewLabel.text = [NSString stringWithFormat:@"%@",[[arrayData objectAtIndex:section]valueForKey:@"question"]];//@"What is your favorite country?";
        viewLabel.font =[UIFont systemFontOfSize:12.0f];
        
        [sectionView addSubview:lblQuestion];
        
        [sectionView addSubview:viewLabel];
        
        
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39, self.tblVW.frame.size.width-15, 1)];
        separatorLineView.backgroundColor = [UIColor blackColor];
        //[sectionView addSubview:separatorLineView];
        
        return  sectionView;

    
    
    
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
    if (section == arrayData.count-1)
    {
        return 50;
    }else{
        return 0.001;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultViewController *result =[self.storyboard instantiateViewControllerWithIdentifier:@"result_view"];
//    total=2;
//    result.strScore =[NSString stringWithFormat:@"%d/5",total];
    
   // [self.navigationController pushViewController:result animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == arrayData.count -1)
    {
        //allocate the view if it doesn't exist yet
        UIView*footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tblVW.frame.size.width, 48)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor =[UIColor colorWithRed:0/255.0f green:211/255.0f blue:186/255.0f alpha:1.0];
        //button.backgroundColor =[UIColor colorWithRed:41/255.0f green:32/255.0f blue:76/255.0f alpha:1.0];

        //the button should be as big as a table view cell
        [button setFrame:CGRectMake(20, 9, self.tblVW.frame.size.width - 40, footerView.frame.size.height-18)];
        
        //set title, font size and font color
        [button setTitle:@"Submit" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 8.0f;
        button.clipsToBounds= YES;
        //set action of the button
        [button addTarget:self action:@selector(submitExambuttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [footerView addSubview:button];
    
    //return the view for the footer
    return footerView;
    }else{
        return nil;
    }
}
#pragma mark
#pragma mark UIButton Methods
#pragma mark
-(void)submitExambuttonAction:(id)sender
{

    [progress setText:@"Time Out"];
    [timer invalidate];
    [self calculateExamScore];
}
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
    
    //  NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)selectBtn], @"selectBtn", nil];
    
    // NSDictionary *outDict=[[NSDictionary alloc]initWithObjectsAndKeys:dictionary,[NSString stringWithFormat:@"%ld",(long)selectSection], nil];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblVW];
    NSIndexPath *indexPath = [self.tblVW indexPathForRowAtPoint:buttonPosition];
    selectSection= indexPath.section;

    [arraySelectedAns replaceObjectAtIndex:selectSection withObject:[NSString stringWithFormat:@"%ld",(long)selectBtn]];
    
    if (indexPath != nil)
    {
        [self.tblVW reloadData];
        
    }
    
    
}
@end
