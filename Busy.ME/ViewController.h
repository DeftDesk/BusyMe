//
//  ViewController.h
//  Busy.ME
//
//  Created by Deft Desk on 12/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIMaster.h"
#import "AppDelegate.h"
#import "Define.h"

@interface ViewController : UIViewController<APIMasterDelegate>{
    NSMutableDictionary *linkedResultDict;

}

@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) NSMutableArray *imgUrlArray;
@property (strong, nonatomic) NSMutableArray *imagesArray;


- (IBAction)LoginWithLinkedinButton:(id)sender;
- (IBAction)LoginWithEmailButton:(id)sender;
- (IBAction)AboutUsButtonClick:(id)sender;

@end

