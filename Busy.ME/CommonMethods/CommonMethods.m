//
//  CommonMethods.m
//  MicroMovers
//
//  Created by saksha on 05/11/15.
//  Copyright © 2015 saksha. All rights reserved.
//

#import "CommonMethods.h"

@interface CommonMethods ()

@end



@implementation CommonMethods


#pragma mark
#pragma mark <UIAnimation>
#pragma mark

// This method animates the container up by value passed in the view passed
+(void)moveContainerUpBy:(NSInteger)value andView:(UIView*)view
{
    [UIView beginAnimations:@"Move Container Up" context:Nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationsEnabled:YES];
    //[view setFrame:CGRectMake(0,-value,kWindowWidth,kWindowHeight)];
    [UIView commitAnimations];
}

// This method animates container back to its initial position
+(void)moveContainerToInitialPositionWithView:(UIView*)view
{
    [UIView beginAnimations:@"Move Container Down" context:Nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationsEnabled:YES];
    //[view setFrame:CGRectMake(0, 0,kWindowWidth,kWindowHeight)];
    [UIView commitAnimations];
}


#pragma mark
#pragma mark <Regular expression>
#pragma mark

// This method checks the format of textfield passed in case of special characters or numbers
+(BOOL)checkUserName:(NSString*)username
{
    NSString *regex = @"[a-zA-Z]*" ;
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [nameTest evaluateWithObject:username];
    return isValid;
}

// This method checks the format of textfield passed in case of numbers
+(BOOL)checkNumber:(NSString*)number
{
    NSString *regex = @"[0-9]*" ;
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [nameTest evaluateWithObject:number];
    return isValid;
}

// This method checks the format of email address
+(BOOL)checkEmail_id:(NSString*)Email_id
{
    NSString *emailRegex = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:Email_id];
    return isValid;
}


#pragma mark
#pragma mark <UIControllers>
#pragma mark

/*
 This method returns alert view with properties
 param title : title of the alert pop up
 param message : message of the alert pop up
 */
+(void)showAlertWithMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(UIView*)returnPaddingView
{
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    return paddingView;
}

#pragma mark
#pragma mark <NSUserDefaults>
#pragma mark

//initialize user defualts with object and key
+(void)initUserDefaults:(id)object andKey:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

// access user defaults with key
+(NSString*)accessUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *strValue = [defaults objectForKey:key];
    return strValue;
}

// access user defaults with key
+(NSDictionary*)getDictWithKey:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:key];
    return dict;
}
// access user defaults with key
+(NSArray*)getArrayWithKey:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:key];
    return arr;
}

+(void)removeUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

#pragma mark
#pragma mark <Editing text>
#pragma mark

+(NSString*)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSInteger)getNumberFromString:(NSString*)str
{
    NSRange beginningOfNumber = [str rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
   // NSRange endingOfNumber = [str rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    //NSString *key           = [str substringFromIndex:endingOfNumber.location];
    NSString *stringValue   = [str substringFromIndex:beginningOfNumber.location];
    NSInteger value         = [stringValue integerValue];
    
    return value;
}

/*
This method  retrun a size of string with given width and font by calculating label height
according to string
param str : string of which height has to be calculated
param width: width of label
param font :font size of label
*/
+(CGSize )calculateHeightAndWidthForLable:(NSString *)str withWidth:(CGFloat )width withFont:(UIFont *)font
{
    CGSize size=CGSizeZero;
    
    if (![str isKindOfClass:[NSNull class]] && str !=nil && [str length]>0)
    {
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:font}];
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        size = rect.size;
    }
    return size;
    
}




// calucates time ago from date (till day)
+(NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:date toDate:[NSDate date]options:0];
    
    if (components.year > 0)
    {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    }
    else if (components.month > 0)
    {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    }
    else if (components.weekOfYear > 0)
    {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    }
    else if (components.day > 0)
    {
        if (components.day > 1)
        {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        }
        else
        {
            return @"Yesterday";
        }
    }
    else
    {
        return @"Today";
    }
}

+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
