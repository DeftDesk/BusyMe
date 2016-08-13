//
//  CommonMethods.h
//  MicroMovers
//
//  Created by saksha on 05/11/15.
//  Copyright © 2015 saksha. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPFloatingPlaceholderTextField.h"


@interface CommonMethods : UIViewController

// moves view up by given value
+(void)moveContainerUpBy:(NSInteger)value andView:(UIView*)view;

// moves view to its original position
+(void)moveContainerToInitialPositionWithView:(UIView*)view;

// checks validity of username
+(BOOL)checkUserName:(NSString*)username;

// checks validity of number
+(BOOL)checkNumber:(NSString*)number;

// checks validity of email address
+(BOOL)checkEmail_id:(NSString*)Email_id;

// presents alert view
+(void)showAlertWithMessage:(NSString*)message;

+(UIView*)returnPaddingView;

//initializies user defaults
+(void)initUserDefaults:(id)object andKey:(NSString*)key;

// access user defaults with key
+(NSString*)accessUserDefaultsWithKey:(NSString*)key;

// removes user defaults
+(void)removeUserDefaultsWithKey:(NSString*)key;

// get dict saved in user defaults
+(NSDictionary*)getDictWithKey:(NSString*)key;

// get arr saved in user defaults
+(NSArray*)getArrayWithKey:(NSString*)key;

// converts base 64 string to data
+(NSString*)base64forData:(NSData*)theData;


// sets image for a url on image view
+(void)SetImageInImageView:(UIImageView *)imageView ForUrl:(NSString *)urlStr;

// extract number from string
+(NSInteger)getNumberFromString:(NSString*)str;

+(CGSize )calculateHeightAndWidthForLable:(NSString *)str withWidth:(CGFloat )width withFont:(UIFont *)font;

+(NSString *)relativeDateStringForDate:(NSDate *)date;

+(UIColor *)colorFromHexString:(NSString *)hexString;


@end
