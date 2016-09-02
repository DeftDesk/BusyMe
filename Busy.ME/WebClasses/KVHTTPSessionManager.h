//
//  KVHTTPSessionManager.h
//  Voncey
//
//  Created by Jin Guanghe on 4/22/15.
//  Copyright (c) 2015 Kooshiar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define BaseURL  @"http://www.jtechappz.co.in/adminpanel/webservice.php"

@interface KVHTTPSessionManager : AFHTTPSessionManager

+ (instancetype) manager;
+ (instancetype) sharedManager;

@end
