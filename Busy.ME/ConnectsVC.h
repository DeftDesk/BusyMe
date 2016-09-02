//
//  ConnectsVC.h
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectsVC : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *arrayUsers;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) IBOutlet UIView *viewCollction;

-(IBAction)BackConnectsButton:(id)sender;

@end
