//
//  AppDelegate.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "AppDelegate.h"
#import "Define.h"
#import "APIMaster.h"


@interface AppDelegate ()
{
    UIView *shield;
    UIActivityIndicatorView *processingActivity;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark
#pragma mark<Processing...>
#pragma mark

// This method prepare activity indicator
-(void)prepareProcessing
{
    shield = [[UIView alloc] initWithFrame:kWindowFrame];
    shield.backgroundColor = [UIColor clearColor];
    
    UIView *processingContainer = [[UIView alloc] initWithFrame:CGRectMake((kWindowWidth-100*kWidthFactor)/2, (kWindowHeight-100*kWidthFactor)/2, 100*kWidthFactor,100*kWidthFactor)];
    processingContainer.backgroundColor = [UIColor clearColor];
    processingContainer.layer.cornerRadius = 5.0;
    
    processingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        processingActivity.transform = CGAffineTransformMakeScale(1.5,1.5);
    }
    processingActivity.color = [UIColor redColor];
    
    processingActivity.frame = CGRectMake((WidthOFRect(processingContainer)-25*kWidthFactor)/2, (HeightOfRect(processingContainer)-25*kHeightFactor)/2, 25*kWidthFactor, 25*kHeightFactor);
    
    [processingContainer addSubview:processingActivity];
    [shield addSubview:processingContainer];
}

+(AppDelegate*)shareDelegates
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

// This method starts activity indicator
-(void)startProcessing
{
    //NSLog(@"Show processing called");
    
    if(![shield superview])
    {
        [self.window addSubview:shield];
        [self.window bringSubviewToFront:shield];
        [processingActivity startAnimating];
    }
}

// This method stops activity indicator
-(void)stopProcessing
{
    //NSLog(@"stop processing called");
    if([shield superview])
    {
        [processingActivity stopAnimating];
        [shield removeFromSuperview];
    }
}



@end
