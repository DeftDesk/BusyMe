//
//  ConnectsVC.m
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "ConnectsVC.h"
#import "ConnectCell.h"
#import "SingleTonClasses.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ConnectsVC ()

@end

@implementation ConnectsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;

    self.viewCollction.layer.borderWidth = 2.0f;
    self.viewCollction.layer.borderColor =[UIColor grayColor].CGColor;
    
    [self.collection registerNib:[UINib nibWithNibName:@"ConnectCell" bundle:nil] forCellWithReuseIdentifier:@"ConnectCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    int cellWidth ;
    CGFloat spacing = 10; // the amount of spacing to appear between image and title
    
    
    if ([UIScreen mainScreen].bounds.size.width == 375)
    {
        cellWidth =  ([UIScreen mainScreen].bounds.size.width/2);
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [flowLayout setItemSize:CGSizeMake(cellWidth+4.5,cellWidth)];
        
    }
    else if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        cellWidth = (self.view.frame.size.width/3);
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayout setItemSize:CGSizeMake(cellWidth-25,cellWidth-25)];
        
    }else{
        cellWidth =  ([UIScreen mainScreen].bounds.size.width/2);
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [flowLayout setItemSize:CGSizeMake(cellWidth,cellWidth)];
    }
    
    [flowLayout setMinimumInteritemSpacing:5];
    [flowLayout setMinimumLineSpacing:9];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collection.backgroundColor = [UIColor whiteColor];
    
    [self.collection setCollectionViewLayout:flowLayout];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getUserDefaults];
    NSArray *arryConnects =[[NSArray alloc]initWithArray:data.contactsDict];
    
    if ([arryConnects [0] valueForKey:@"Message"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No User Available In Specified Category"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
        arrayUsers =[[NSMutableArray alloc]init];
        for (int i =0; i < arryConnects.count; i++)
        {
            if ([arryConnects[i][@"connected"]integerValue] == 1)
            {
                [arrayUsers addObject:arryConnects[i]];
            }
        }
        [self.collection reloadData];
    }
    if (arrayUsers.count == 0)
    {
        [self noConnectsUserFound];
    }

}

-(void)noConnectsUserFound
{
    UIFont * customFont = [UIFont boldSystemFontOfSize:22.0f]; //custom font
    NSString * text = @"NO CONNECTS";
    CGRect frame = self.viewCollction.frame;
    

    frame.origin.y = (frame.size.height- 40)/2;
//    frame.origin.x = frame.size.width/2;
    frame.size.height = 40;
    frame.size.width = frame.size.width - 40;
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:frame];
    fromLabel.text = text;
    fromLabel.font = customFont;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    [self.collection addSubview:fromLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark <UICollectionViewDataSource>
#pragma mark

// Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ConnectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ConnectCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor clearColor];
    
    cell.lblName.text = [arrayUsers[indexPath.row][@"name"]capitalizedString];
    cell.lblName.adjustsFontSizeToFitWidth = YES;
    [cell.imgDP sd_setImageWithURL:[NSURL URLWithString:arrayUsers[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
    
    return cell;
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100,100);
//}

#pragma mark
#pragma mark <UICollectionViewDelegate>
#pragma mark

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}



@end
