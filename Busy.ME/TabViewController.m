//
//  TabViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 25/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;

    [self.TabBar setTintColor:[UIColor whiteColor]];
    
    UITabBarItem *item = (UITabBarItem*)[self.TabBar.items objectAtIndex:0];
    UITabBarItem *item1 = (UITabBarItem*)[self.TabBar.items objectAtIndex:1];
    UITabBarItem *item2 = (UITabBarItem*)[self.TabBar.items objectAtIndex:2];
    UITabBarItem *item3 = (UITabBarItem*)[self.TabBar.items objectAtIndex:3];
    
    [item setImage:[[UIImage imageNamed:@"linkIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitle:@"Link"];
    
    [item1 setImage:[[UIImage imageNamed:@"chatIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitle:@"Chat"];
    
    [item2 setImage:[[UIImage imageNamed:@"connectsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitle:@"Connects"];
    
    [item3 setImage:[[UIImage imageNamed:@"profileTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitle:@"Profile"];
    
    
    [item setSelectedImage:[[UIImage imageNamed:@"linkIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item1 setSelectedImage:[[UIImage imageNamed:@"chatIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item2 setSelectedImage:[[UIImage imageNamed:@"connectsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item3 setSelectedImage:[[UIImage imageNamed:@"profileTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor redColor]}
//                                             forState:UIControlStateSelected];

    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor colorWithRed:41/255.0f green:32/255.0f blue:76/255.0f alpha:1]}
                                             forState:UIControlStateSelected];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
