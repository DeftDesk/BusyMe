//
//  APIMaster.h
//  AttendanceFees
//
//  Created by Apple on 13/06/14.
//  Copyright (c) 2014 intersoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Define.h"
#import "AppDelegate.h"
#import "CommonMethods.h"

@protocol APIMasterDelegate <NSObject>

@required
/*
 This method sends request to web server with parameters
 param dataStr : data to be send to server
 */
-(void)responseFromWeb:(id)response;

@end

@interface APIMaster : NSObject


-(void)sendRequestToWebWithActionName:(NSString*)actionName andDict:(NSString*)dict;
-(void)sendRequestToWebWithInputStr:(NSString*)inputStr;
- (void)sendImageToServerWithDict:(NSMutableDictionary*)dict andActionName:(NSString*)actionName andImgParameterName:(NSString*)imgParam andImgData:(NSData*)imgData;

@property(nonatomic, strong)id<APIMasterDelegate>delegate;

@end
