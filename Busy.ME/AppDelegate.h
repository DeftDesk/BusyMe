//
//  AppDelegate.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)shareDelegates;
-(void)getRootNavigationController;

-(void)startProcessing;
-(void)stopProcessing;

@end

