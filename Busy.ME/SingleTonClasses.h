//
//  SingleTonClasses.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTonClasses : NSObject

+ (id)sharedManager;

@property (strong, nonatomic) NSArray *contactsDict;
@property (strong, nonatomic) NSArray *interstArray;


-(void)saveUserDefaults;

-(void)saveInterestDefaults;

-(void)getUserDefaults;

-(void)getInterestDefaults;


@end
