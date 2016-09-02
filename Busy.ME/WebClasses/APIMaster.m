///
//  APIMaster.m
//  AttendanceFees
//
//  Created by Apple on 13/06/14.
//  Copyright (c) 2014 intersoft. All rights reserved.
//

#import "APIMaster.h"
#import "KVHTTPSessionManager.h"

#import "MBProgressHUD.h"

@implementation APIMaster


-(void)sendRequestToWebWithActionName:(NSString*)actionName andDict:(NSString*)dict
{
     [[AppDelegate shareDelegates]startProcessing];
    
    /*NSURL *url = [NSURL URLWithString:kCommonUrl];
    NSDictionary *params = dict;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFFormURLParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
   // NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
   // NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:actionName parameters:params];
 //   [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSLog(@"request>> %@",request);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error = nil;
         
         id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
       
         [[AppDelegate shareDelegates]stopProcessing];

         [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:response waitUntilDone:NO];
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
          [[AppDelegate shareDelegates]stopProcessing];
         if([operation.response statusCode] == 406)
         {
             [CommonMethods showAlertWithMessage:@"Please login"];
             return;
         }
         
         if([operation.response statusCode] == 403)
         {
             NSLog(@"Upload Failed");
             return;
         }
         if ([[operation error] code] == -1009)
         {
             
         }
         else if ([[operation error] code] == -1001)
         {
             [self sendRequestToWebWithActionName:actionName andDict:dict];
         }
     }];
    [operation start];*/
    
  

    [[KVHTTPSessionManager sharedManager] POST:actionName parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
        [[AppDelegate shareDelegates]stopProcessing];
        
        [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:responseObject waitUntilDone:NO];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[AppDelegate shareDelegates]stopProcessing];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;

        if([response statusCode] == 406)
        {
            [CommonMethods showAlertWithMessage:@"Please login"];
            return;
        }
        
        if([response statusCode] == 403)
        {
            NSLog(@"Upload Failed");
            return;
        }
        if ([[task error] code] == -1009)
        {
            
        }
        else if ([[task error] code] == -1001)
        {
            [self sendRequestToWebWithActionName:actionName andDict:dict];
        }
    }];
}


// This method gets response from web and check what type of data it is
-(void)responseFromWeb:(id)response
{
    [[AppDelegate shareDelegates]stopProcessing];
    
    if([response isKindOfClass:[NSDictionary class]])
        response = (NSDictionary*)response;
    else if([response isKindOfClass:[NSArray class]])
        response = (NSMutableArray*)[response mutableCopy];
    else if([response isKindOfClass:[NSString class]])
        response = (NSString*)response;
    else
        response = nil;
    
    [self.delegate responseFromWeb:response];
}
-(void)sendGetNewRequestToWebWithString:(NSString *)inputStr{
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"45fa78e7-3082-851f-baaa-d5abc4d4c5e0" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[inputStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:100.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"data is =%@",json);
                                                        [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:json waitUntilDone:NO];

                                                    }
                                                }];
    [dataTask resume];
    
}
-(void)sendRequestToWebWithInputStr:(NSString*)inputStr
{
    [[AppDelegate shareDelegates]startProcessing];
    
   /* AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kCommonUrl]];
    httpClient.parameterEncoding = AFFormURLParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *tempStr = [inputStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:tempStr parameters:nil];
    NSLog(@"request>> %@",request);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error = nil;
         
         id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
          [[AppDelegate shareDelegates]stopProcessing];
         [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:response waitUntilDone:NO];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate shareDelegates]stopProcessing];
         if([operation.response statusCode] == 406)
         {
             [CommonMethods showAlertWithMessage:@"Please login"];
             return;
         }
         
         if([operation.response statusCode] == 403)
         {
             NSLog(@"Upload Failed");
             return;
         }
         if ([[operation error] code] == -1009)
         {
             
         }
         else if ([[operation error] code] == -1001)
         {
             [self sendRequestToWebWithInputStr:inputStr];
         }
         else
         {
             NSLog(@"Please try again");
         }
     }];
    [operation start];*/
    [[KVHTTPSessionManager sharedManager] GET:[inputStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[AppDelegate shareDelegates]stopProcessing];
        [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:responseObject waitUntilDone:NO];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;

        [[AppDelegate shareDelegates]stopProcessing];
        UIViewController *view = (UIViewController*)self.delegate;
        [MBProgressHUD hideHUDForView:view.view animated:true];

        if([response statusCode] == 406)
        {
            [CommonMethods showAlertWithMessage:@"Please login"];
            return;
        }
        
        if([response statusCode] == 403)
        {
            NSLog(@"Upload Failed");
            return;
        }
        if ([[task error] code] == -1009)
        {
            
        }
        else if ([[task error] code] == -1001)
        {
            [self sendRequestToWebWithInputStr:inputStr];
        }
        else
        {
            NSLog(@"Please try again");
        }
    }];
}

- (void)sendImageToServerWithDict:(NSMutableDictionary*)dict andActionName:(NSString*)actionName andImgParameterName:(NSString*)imgParam andImgData:(NSData*)imgData
{
    [[AppDelegate shareDelegates]startProcessing];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    NSMutableDictionary *parameters = dict;

    // add params (all params are strings)
    for (NSString *param in parameters)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *FileParamConstant = imgParam;
    
    if (imgData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSString *requestStr = [NSString stringWithFormat:@"%@/%@",kCommonUrl,actionName];
    NSURL *url = [NSURL URLWithString:[requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError == nil && data != nil)
         {
             id responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             
             [[AppDelegate shareDelegates]stopProcessing];
             [self performSelectorOnMainThread:@selector(responseFromWeb:) withObject:responseData waitUntilDone:NO];
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [[AppDelegate shareDelegates] stopProcessing];
             });
         }
     }];
}

@end
