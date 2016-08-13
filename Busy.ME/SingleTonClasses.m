//
//  SingleTonClasses.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "SingleTonClasses.h"

static SingleTonClasses *sharedManager = nil;

@implementation SingleTonClasses

+ (id)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
