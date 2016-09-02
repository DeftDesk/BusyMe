//
//  ChatViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 30/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "SVPullToRefresh.h"
#import "OpenChatVC.h"
#import "MBProgressHUD.h"
#import "CommonMethods.h"
#import "Define.h"

@interface ChatViewController ()<OpenChatVCDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"ChatViewCell" bundle:nil];
    [self.tblChat registerNib:cellNib forCellReuseIdentifier:@"ChatViewCell"];
    __weak ChatViewController *weakSelf = self;
    
   // [self setupDataSource];

    // setup pull-to-refresh
    [self.tblChat addPullToRefreshWithActionHandler:^{
        [weakSelf GetUserFriendChatsFromServerByUserId];
    }];
   // [self.tblChat triggerPullToRefresh];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [self GetUserFriendChatsFromServerByUserId];
    // setup infinite scrolling
//    [self.tblChat addInfiniteScrollingWithActionHandler:^{
//        //[weakSelf insertRowAtBottom];
//    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
   
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tblChat respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblChat setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblChat respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblChat setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)GetUserFriendChatsFromServerByUserId{
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"88b26d93-6cc5-b8cb-0726-a92b74711d18" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=mychatlist&userid=%@",[CommonMethods accessUserDefaultsWithKey:kUserId]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:100.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"data is =%@",json);
                                                        NSArray *arr = [json objectForKey:@"userprofile"];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            if (arr.count > 0)
                                                            {
                                                                [self performSelectorOnMainThread:@selector(insertRowAtTop:) withObject:[json objectForKey:@"userprofile"] waitUntilDone:NO];
                                                            }else{
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                            }
                                                            
                                                            
                                                            
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}
#pragma mark - Actions

- (void)setupDataSource {
    self.dataSource = [NSMutableArray array];
    for(int i=0; i <10; i++)
        [self.dataSource addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*90)]];
}

- (void)insertRowAtTop:(NSArray*)array {
    __weak ChatViewController *weakSelf = self;
    self.dataSource = [NSMutableArray array];

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //[weakSelf.tblChat beginUpdates];
        for (int i=0; i < array.count; i++)
        {
            [self.dataSource addObject:array[i]];
        }
//        [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
//        [weakSelf.tblChat insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        //[weakSelf.tblChat endUpdates];
        [self.tblChat reloadData];

        [weakSelf.tblChat.pullToRefreshView stopAnimating];

    });
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [self.tblChat reloadData];

}


- (void)insertRowAtBottom {
    __weak ChatViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tblChat beginUpdates];
        [weakSelf.dataSource addObject:[weakSelf.dataSource.lastObject dateByAddingTimeInterval:-90]];
        [weakSelf.tblChat insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tblChat endUpdates];
        
        [weakSelf.tblChat.infiniteScrollingView stopAnimating];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ChatViewCell";
    
    ChatViewCell *cell = (ChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    [cell setFriendsChatDetails:self.dataSource[indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
    [self.tblChat reloadData];
    lastIndex = indexPath.row;
    OpenChatVC *exam =[self.storyboard instantiateViewControllerWithIdentifier:@"open_chat"];
    exam.delegate = self;
//    NSDate *date = [self.dataSource objectAtIndex:indexPath.row];
    exam.strSenderName = [[self.dataSource objectAtIndex:indexPath.row] valueForKey:@"name"];
    exam.strFriendUserId =[[[self.dataSource objectAtIndex:indexPath.row] valueForKey:@"userid"]capitalizedString];
    //[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    [self.navigationController pushViewController:exam animated:true];
    
}

#pragma mark
#pragma mark OpenChatDelegate Methods
#pragma mark
-(void)updateLastMessageWithinputString:(NSString *)message
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]initWithDictionary:self.dataSource[lastIndex]];
    [dict removeObjectForKey:@"message"];
    [dict setObject:message forKey:@"message"];
    [self.dataSource replaceObjectAtIndex:self.dataSource.count-1 withObject:dict];
    [self.tblChat reloadData];
}
@end
