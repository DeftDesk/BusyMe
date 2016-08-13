//
//  KVHTTPSessionManager.h
//  Voncey
//
//  Created by Jin Guanghe on 4/22/15.
//  Copyright (c) 2015 Kooshiar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define BaseURL  @"http://pinkypromise.smallarmydev.net/webservices"//@"http://pinkypromise.smallarmydev.net/webservices"

@interface KVHTTPSessionManager : AFHTTPSessionManager

+ (instancetype) manager;
+ (instancetype) sharedManager;

@end
