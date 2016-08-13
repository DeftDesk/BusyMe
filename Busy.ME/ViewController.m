//
//  ViewController.m
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ViewController.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "AFHTTPRequestOperation.h"
#import "Define.h"
#import "IndustriesViewController.h"

@interface ViewController ()

@property (nonatomic, strong) LIALinkedInHttpClient *client;

@end
typedef NS_ENUM(NSInteger, kActionType)
{
    kActionTypeLoginWithEmail,
    kActionTypeLoginWithLinkedin,
    kActionTypeRegisterWithLinkedin,
};

kActionType actionTypeLogin;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;
    self.viewBottom.layer.borderWidth = 2.0f;
    self.viewBottom.layer.borderColor =[UIColor grayColor].CGColor;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (IBAction)LoginWithLinkedinButton:(id)sender {
    [self loginWithLinkedIn];
}

- (IBAction)LoginWithEmailButton:(id)sender {
    
    IndustriesViewController *viewController =[[IndustriesViewController alloc]init];
    
    viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (IBAction)AboutUsButtonClick:(id)sender {
}

#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)loginWithLinkedIn {
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken {
    
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,email-address,picture-urls::(original))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        NSLog(@"current user %@", result);
        
        linkedResultDict = result;
        actionTypeLogin = kActionTypeRegisterWithLinkedin;
        
        [self sendRequestToWeb];
        
    }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"failed to fetch current user %@", error);
                 
             }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://www.jtechappz.com"
                                                                                    clientId:@"813fgu52oebjox"
                                                                                clientSecret:@"vKF7mHJFZKNuKyC5"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}
#pragma mark
#pragma mark <UIResponder Methods>
#pragma mark

// UI Responder Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)postWithLinkedinDataOnServer{
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"001d1925-ebee-7b2e-c2ac-cfcb00c83f1b" };
    NSArray *parameters = @[ @{ @"name": @"email", @"value": @"virenderswami55@gmail.com" },
                             @{ @"name": @"fname", @"value": @"rohankakkar" },
                             @{ @"name": @"lname", @"value": @"jtechappz" },
                             @{ @"name": @"password", @"value": @"rohankakkar" },
                             @{ @"name": @"regtype", @"value": @"L" },
                             @{ @"name": @"user_pic", @"value": @"" } ];
    NSString *boundary = @"---011000010111000001101001";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://pinkypromise.smallarmydev.net/webservices/signup"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark
#pragma mark <API Methods>
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    if (actionTypeLogin == kActionTypeLoginWithEmail)
    {
        //[apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"%@/%@/%@/%@/E",kCommonUrl,klogin,text_email.text,text_pwsd.text]];
    }
    else if (actionTypeLogin == kActionTypeRegisterWithLinkedin){
        NSString *profileUrl ;
        if ([[[linkedResultDict objectForKey:@"pictureUrls"] objectForKey:@"_total"] integerValue] > 0)
        {
            profileUrl =[NSString stringWithFormat:@"%@",[[[linkedResultDict objectForKey:@"pictureUrls"] objectForKey:@"values"] objectAtIndex:0]];
        }else{
            profileUrl =@"";
        }
        
//        NSString *postStr = [NSString stringWithFormat:@"email=%@&name=%@&phone=%@&loginmethod=linkedin&user_pic=%@",[linkedResultDict objectForKey:@"emailAddress"],[linkedResultDict objectForKey:@"firstName"],[linkedResultDict objectForKey:@"lastName"],profileUrl];
        
         NSString *postStr = [NSString stringWithFormat:@"email=%@&name=%@&password=123456&phone=1234567890&loginmethod=linkedin",[linkedResultDict objectForKey:@"emailAddress"],[linkedResultDict objectForKey:@"firstName"]];
        [self sendLinkedInDataOnServer];
        //[apimaster sendRequestToWebWithActionName:[NSString stringWithFormat:@"%@/adduser",kCommonUrl] andDict:postStr];
    }
    else if (actionTypeLogin == kActionTypeLoginWithLinkedin)
    {
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"regWithEmail"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"%@/%@/id=%@",kCommonUrl,klogin,[CommonMethods accessUserDefaultsWithKey:kUserId]]];
    }
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    if ((actionTypeLogin == kActionTypeLoginWithEmail)|| (actionTypeLogin == kActionTypeLoginWithLinkedin))
    {
        if ([[[response objectForKey:@"result"]objectForKey:kStatus]isEqualToString:@"S"])
        {
            [CommonMethods initUserDefaults:@"1" andKey:kIsLogin];
            [CommonMethods initUserDefaults:[[response objectForKey:@"result"] objectForKey:kUserData] andKey:kUserData];
            [CommonMethods initUserDefaults:[[[response objectForKey:@"result"] objectForKey:kUserData]objectForKey:kUserId] andKey:kUserId];
            [CommonMethods initUserDefaults:[[[response objectForKey:@"result"] objectForKey:kUserData]objectForKey:kProfilePic] andKey:kProfilePic];
            
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"regWithEmail"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        else
        {
            [CommonMethods showAlertWithMessage:@"Invalid credentials, Please check and try again."];
        }
    }
    else if (actionTypeLogin == kActionTypeRegisterWithLinkedin)
    {
        if ([response[@"status"] integerValue]==0)
        {
            [CommonMethods showAlertWithMessage:response[@"message"]];
        }else{
            [CommonMethods initUserDefaults:[[response objectForKey:@"data"] objectForKey:@"id"] andKey:kUserId];

            actionTypeLogin = kActionTypeLoginWithLinkedin;
            [self sendRequestToWeb];

        }
    }
}
-(void)sendLinkedInDataOnServer{
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"458b23bc-d5ea-f060-c419-5adf3bc5a5a6" };
    
    NSString *url = [NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=adduser&name=%@&email=%@&phone=&loginmethod=linkedin",[linkedResultDict objectForKey:@"firstName"],[linkedResultDict objectForKey:@"emailAddress"]];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"data is =%@",json);
                                                      
                                                        NSArray *dict = [json valueForKey:@"data"];
                                                        
                                                        NSLog(@"%@",[dict valueForKey:@"Message" ]);

                                                    
            if ([[json objectForKey:@"status"]boolValue]) {
               
                
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                       IndustriesViewController *viewController =[[IndustriesViewController alloc]init];
                        
                        viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
                        
                        [self.navigationController pushViewController:viewController animated:true];
                        
                    });    
            
                
                
               
                
                                                        }
            else{
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict = [json valueForKey:@"data"];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                     });
            }
                                                    }
                                                }];
    [dataTask resume];
    
   }


@end
