//
//  Define.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6Plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define WIDTH      self.view.frame.size.width
#define HEIGHT      self.view.frame.size.height

#define KGreenColor  [UIColor colorWithRed:0.0/255.0 green:213.0/255.0 blue:183.0/255.0 alpha:1.0]


#define ColorWithRGBAlpha(r,g,b,a)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWithRGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]



#define kRegularFont            @"Roboto-Regular"
#define kLightFont              @"Roboto-Light"




#define kCommonUrl @"http://www.jtechappz.co.in/adminpanel/webservice.php"


//------------------------------------------------- initialUrl--------------------------------------------

//----------------------------------------APIs-------------------------------------

#define ksignup                  @"adduser"
#define klogin                   @"get_user_byid"
#define klogout                  @"logout"
#define kForgot                  @"forgotpassword"
#define kupdateprofile           @"updateprofile"
#define kchangepassword          @"resetpassword"
#define kMyContacts              @"myallcontacts"
#define kMadeByMe                @"madebyme"
#define kNewContact              @"newcontact64"
#define kGetAllCat               @"getallcategorys"
#define kNewPromise              @"newpromise"
#define kNewRequest              @"sendrequest"
#define kMadeToMe                @"madetome"
#define kUserDetails             @"userdetails"
#define kUserStatic              @"statics"
#define kUserAchivements         @"acheivements"
#define kUserChat                @"chatapi"
#define kUserChatSave            @"chatsave"
#define kUpdatePromise           @"updatepromise"
#define kCounterProposal         @"counter_proposal"
#define kPromiseTodo             @"promisetodo"
#define kDeletePromise           @"deletepromise"
#define kSearchNewUser           @"searchuser"
#define kNotificationGet         @"allnotification"


#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



//------------------------------------------------ response checks --------------------------------------



#define kMessage          @"message"
#define kResult           @"result"
#define kStatus           @"status"
#define kIsLogin          @"isLogined"
#define kUserData         @"userdata"
#define kLoginUserDetails @"loginUserDetails"
#define kUserId           @"userid"
#define kEmail            @"email"
#define kCatID            @"category_id"
#define kProfilePic      @"ppic"// @"profile_pic"
//#define kProfilePicLogin       @"profile_pic"

#define kTrimTxt(str)                       [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]





#define KpopToRoot   [self.navigationController popToRootViewControllerAnimated:YES]
#define KpushTo(view)   [self.navigationController pushViewController:view animated:YES]
#define KinstantiateVC(identifier) [self.storyboard instantiateViewControllerWithIdentifier:identifier]
#define KpopView     [self.navigationController popViewControllerAnimated:YES]

#define kAppId @"645549492226489"
#define kClientId @"301196367849-2vb09e6id8c5tn624hpobp759c9sa62e.apps.googleusercontent.com"

#define kzoomid [[NSUserDefaults standardUserDefaults]valueForKey :@"zoomtokenid"]

#define kzoomtokenid [[NSUserDefaults standardUserDefaults]valueForKey :@"zoomid"]



//



//----------------------------------------------------- alertView-----------------------------------------------

#define KFontSizeHTML UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"44px" : @"50px"
#define KFontSizeHTMLIphone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"28px" : @"50px"

#define KShowErrorAlertView(title, MessageObj) [[[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@",MessageObj.description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

#define kAlertController *alert = [UIAlertController alertControllerWithTitle: title == nil ? @"": title message: message preferredStyle: UIAlertControllerStyleAlert];


#define KAlertView(title, Message) [[[UIAlertView alloc] initWithTitle:title message:Message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

//-------------------------------------------- SVProgressHUD-----------------------------
#define KShowHud(MSG) [SVProgressHUD showWithStatus:MSG]
#define KDismissHud [SVProgressHUD dismiss]
//------------------------------------------ Save User deatial-----------------------------

#define KSaveUserDeatil(userDetail) [[NSUserDefaults standardUserDefaults] setValue:userDetail forKey:@"userInfo"]; [[NSUserDefaults standardUserDefaults] synchronize]
#define KgetUserDeatil [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]
#define KcheckUserDeatil [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]

#define kSaveUserDetailData(userDetail) [[NSUserDefaults standardUserDefaults] setValue:userDetail forKey:@"userDetail"]; [[NSUserDefaults standardUserDefaults] synchronize]
#define KgetUserDeatilData [[NSUserDefaults standardUserDefaults] valueForKey:@"userDetail"]
//------------------------------------------- remove all UserDefaults deatil ---------------------------
#define KRemoveUserDeatil NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier]; [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain]



#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define WidthOFRect(r)                      r.frame.size.width
#define HeightOfRect(r)                     r.frame.size.height
#define XOriginOfRect(r)                    r.frame.origin.x
#define YOriginOfRect(r)                    r.frame.origin.y

#define kWindowFrame                        [[UIScreen mainScreen] bounds]
#define kWindowWidth                          kWindowFrame.size.width
#define kWindowHeight                          kWindowFrame.size.height

#define kHeightFactor       ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?2:kWindowHeight/480)
#define kWidthFactor        ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?2.377:kWindowWidth/320)


#endif /* Define_h */
