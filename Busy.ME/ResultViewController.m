//
//  ResultViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 16/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ResultViewController.h"
#import "IndustriesViewController.h"
#import "SingleTonClasses.h"
#import "ProfilesViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vwLine.layer.borderWidth = 2.0f;
    self.vwLine.layer.borderColor =[UIColor grayColor].CGColor;
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"PAY $2 TO RETAKE"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0f green:211/255.0f blue:186/255.0f alpha:1.0] range:NSMakeRange(3,4)];
    [string addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:25.0]
                  range:NSMakeRange(3, 4)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(11,5)];
    self.lblRetake.attributedText = string;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getUserDefaults];
    NSArray *arr =[[NSArray alloc]initWithArray:data.contactsDict];
    if ([arr [0] valueForKey:@"Message"]) {
    }
    [self.lblTotalScore setText:[NSString stringWithFormat:@"YOU HAVE SCORED %@",self.strScore]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UIButton Methods
#pragma mark
-(void)backButtonClick:(id)sender{
//    [self.navigationController popViewControllerAnimated:true];
    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for (int i = 0; i < [viewControllers count]; i++){
        id obj = [viewControllers objectAtIndex:i];
        if ([obj isKindOfClass:[IndustriesViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
}
-(IBAction)RetakeTestClick:(id)sender{
    
}
-(IBAction)ContinueButtonClick:(id)sender
{
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getUserDefaults];
    NSArray *arryConnects =[[NSArray alloc]initWithArray:data.contactsDict];
    if ([arryConnects [0] valueForKey:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No User Available In Specified Category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"tab_view"];
        [self.navigationController showViewController:tabView sender:nil];
        
        //        ProfilesViewController *profile =[self.storyboard instantiateViewControllerWithIdentifier:@"profile_view"];
        //
        //        [self.navigationController pushViewController:profile animated:true];
    }
}
#pragma mark
#pragma mark UIAlertView Delegate Methods
#pragma mark

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for (int i = 0; i < [viewControllers count]; i++){
            id obj = [viewControllers objectAtIndex:i];
            if ([obj isKindOfClass:[IndustriesViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    }
}
@end
