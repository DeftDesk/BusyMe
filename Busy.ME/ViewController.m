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
#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"

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
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;

//    UINavigationController *navcontroller=(UINavigationController*)app.window.rootViewController;
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    if ([[CommonMethods accessUserDefaultsWithKey:kIsLogin] isEqualToString:@"1"])
//    {
//        if ([[CommonMethods accessUserDefaultsWithKey:kIsExam] isEqualToString:@"1"])
//        {
//            UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"tab_view"];
//            navcontroller.viewControllers=@[tabView];
//            
//            //            [self.navigationController showViewController:tabView sender:nil];
//        }else{
//            IndustriesViewController *creat=[storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
//            navcontroller.viewControllers=@[creat];
//            
//        }
//    }
    
}
- (IBAction)LoginWithLinkedinButton:(id)sender {
    [self loginWithLinkedIn];
}

- (IBAction)LoginWithEmailButton:(id)sender {
    
    IndustriesViewController *viewController =[[IndustriesViewController alloc]init];
    
    viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
    
    //[self.navigationController pushViewController:viewController animated:true];
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
    
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,phonetic-last-name,email-address,phone-numbers,positions:(title,company),picture-urls::(original))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
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
        NSString *strPositions ;

        self.imgUrlArray = [[NSMutableArray alloc]init];
        NSArray *pictureUrls = linkedResultDict[@"pictureUrls"][@"values"];
        if ([pictureUrls isKindOfClass:[NSArray class]]) {
            if (pictureUrls.count > 0) {
                [self.imgUrlArray addObjectsFromArray:pictureUrls];
            }
        }

        
        if ([[[linkedResultDict objectForKey:@"pictureUrls"] objectForKey:@"_total"] integerValue] > 0)
        {
            profileUrl =[NSString stringWithFormat:@"%@",[[[linkedResultDict objectForKey:@"pictureUrls"] objectForKey:@"values"] objectAtIndex:0]];
        }else{
            profileUrl =@"";
        }
        if ([[[linkedResultDict objectForKey:@"positions"] objectForKey:@"_total"] integerValue] > 0)
        {
            strPositions =[NSString stringWithFormat:@"%@ at %@",[[[[linkedResultDict objectForKey:@"positions"] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"title"],[[[[[linkedResultDict objectForKey:@"positions"] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"company"] objectForKey:@"name"]];
        }else{
            strPositions =@"";
        }
        
//        NSString *postStr = [NSString stringWithFormat:@"email=%@&name=%@&phone=%@&loginmethod=linkedin&user_pic=%@",[linkedResultDict objectForKey:@"emailAddress"],[linkedResultDict objectForKey:@"firstName"],[linkedResultDict objectForKey:@"lastName"],profileUrl];
        
//         NSString *postStr = [NSString stringWithFormat:@"email=%@&name=%@&password=123456&phone=1234567890&loginmethod=linkedin",[linkedResultDict objectForKey:@"emailAddress"],[linkedResultDict objectForKey:@"firstName"]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //[self sendLinkedInDataOnServer];
        //[apimaster sendRequestToWebWithActionName:[NSString stringWithFormat:@"%@/adduser",kCommonUrl] andDict:postStr];
      //  NSString *url = [NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=adduser&name=%@&email=%@&phone=&loginmethod=linkedin",[linkedResultDict objectForKey:@"firstName"],[linkedResultDict objectForKey:@"emailAddress"]];
       
        NSMutableDictionary *param=[NSMutableDictionary new];
        [param setValue:@"adduser" forKey:@"action"];
        [param setValue:[linkedResultDict objectForKey:@"emailAddress"] forKey:@"email"];
        [param setValue:[linkedResultDict objectForKey:@"firstName"] forKey:@"name"];
        [param setValue:[linkedResultDict objectForKey:@""] forKey:@"phone"];
        [param setValue:@"linkedin" forKey:@"loginmethod"];

        [param setValue:strPositions forKey:@"designation"];
        
        [self sentImage:param url:@"http://www.jtechappz.co.in/adminpanel/webservice.php"];
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
        if ([response[@"status"] integerValue]==0)
        {
            [CommonMethods showAlertWithMessage:response[@"message"]];
        }else{
            
            [CommonMethods initUserDefaults:[[response objectForKey:@"data"] objectForKey:@"id"] andKey:kUserId];
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
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:500.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        });
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"data is =%@",json);
                                                      
                                                        NSArray *dict = [json valueForKey:@"data"];
                                                        
                                                        NSLog(@"%@",[dict valueForKey:@"Message" ]);

                                                    
            if ([[json objectForKey:@"status"]boolValue]) {
               
                NSArray *array =[json valueForKey:@"data"];

                [CommonMethods initUserDefaults:[[array objectAtIndex:0] valueForKey:@"id"] andKey:kUserId];
                [CommonMethods initUserDefaults:@"1" andKey:kIsLogin];
                
                if ([[[linkedResultDict objectForKey:@"positions"] objectForKey:@"_total"] integerValue] > 0)
                {
                    [CommonMethods initUserDefaults:[linkedResultDict objectForKey:@"positions"] andKey:kUserPosition];

                }
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                       IndustriesViewController *viewController =[[IndustriesViewController alloc]init];
                        
                        viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
                        
                        [self.navigationController pushViewController:viewController animated:true];
                        
                    });    
            
                
                
               
                
                                                        }
            else{
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict = [json valueForKey:@"data"];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[dict valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                     });
            }
                                                    }
                                                }];
    [dataTask resume];
    
   }


#pragma mark
#pragma mark MultiPartRequest Methods
#pragma mark

-(void)sentImage:(NSDictionary *)paramData url:(NSString *)url {
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    self.imagesArray = [[NSMutableArray alloc]init];
    NSError *error = nil;
    for (int i = 0; i < 5; i++) {
        if (i < self.imgUrlArray.count) {
            NSURL *url1 = [[NSURL alloc]initWithString:[self.imgUrlArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
            NSData *imgData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            UIImage *img = [UIImage imageWithData:imgData];
            [self.imagesArray addObject:img];
        }
        else {
           // [self.imagesArray addObject:[UIImage imageNamed:@"addImage"]];
        }
        
    }

    
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    [request setURL:requestURL];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in paramData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [paramData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
       for (int i = 0; i < self.imagesArray.count; i++) {
        UIImage *img1 = self.imagesArray[i];
        UIImage *img = [UIImage imageNamed:@"addImage"];
        NSData *imgData1 = UIImagePNGRepresentation(img1);
        NSData *imgData2 = UIImagePNGRepresentation(img);
        
        BOOL isCompare =  [imgData1 isEqual:imgData2];
        if (!isCompare) {
            
            UIImage *image = self.imagesArray[i];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSData* imageData = UIImagePNGRepresentation(image);
            NSLog(@"added %i", i+1);
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file_%i\"; filename=\"image%i.png\"\r\n", i + 1, i+ 1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }

    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        });
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        NSLog(@"data is =%@",json);
                                                        
                                                        
                                                        
                                                        
                                                        if ([[json objectForKey:@"status"]boolValue]) {
                                                            
                                                            NSArray *array =[json valueForKey:@"userprofile"];
                                                            
                                                            [CommonMethods initUserDefaults:[[array objectAtIndex:0] valueForKey:@"userid"] andKey:kUserId];
                                                            
                                                            [CommonMethods initUserDefaults:@"1" andKey:kIsLogin];
                                                           
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                IndustriesViewController *viewController =[[IndustriesViewController alloc]init];
                                                                
                                                                viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"industriesVC"];
                                                                
                                                                [self.navigationController pushViewController:viewController animated:true];
                                                                
                                                            });    
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        else{
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[json objectForKey:@"data"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                [alert show];
                                                                
                                                            });
                                                        }
                                                    }
                                                }];
    [dataTask resume];

    
}


@end
