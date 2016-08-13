//
//  KVHTTPSessionManager.m
//  Voncey
//
//  Created by Jin Guanghe on 4/22/15.
//  Copyright (c) 2015 Kooshiar. All rights reserved.
//

#import "KVHTTPSessionManager.h"

@implementation KVHTTPSessionManager

+ (instancetype)manager {
    
    NSURL *url = [NSURL URLWithString:BaseURL];
    return [[[self class] alloc] initWithBaseURL:url];
    
}

+ (instancetype) sharedManager {
    static KVHTTPSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        
    });
    return _sharedManager;

}

@end
