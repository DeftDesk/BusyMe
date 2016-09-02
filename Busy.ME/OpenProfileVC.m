//
//  OpenProfileVC.m
//  Busy.ME
//
//  Created by Deft Desk on 22/08/16.
//  Copyright © 2016 jTechAppz. All rights reserved.
//

#import "OpenProfileVC.h"

#import "Define.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "APIMaster.h"
#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "SingleTonClasses.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserProfileCell.h"
#import "SettingsVC.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "DZImageEditingController.h"


@interface OpenProfileVC ()<APIMasterDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DZImageEditingControllerDelegate>

@end
#define kTagContactImg          6789
#define kTagContactName         6790

@implementation OpenProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImage *overlayImage = [UIImage imageNamed:@"overlay200"];
    self.overlayImageView = [self createOverlayImageViewWithImage:overlayImage];
    self.overlayImageView.image = overlayImage;
    
    [self.btnDropDown addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.txtInterst.layer.cornerRadius  = 3.0f;
    self.txtInterst.layer.borderWidth = 1.0f;
    self.txtInterst.layer.borderColor = [UIColor grayColor].CGColor;
    [self.txtInterst setClipsToBounds:YES];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.txtInterst.leftView = paddingView;
    self.txtInterst.leftViewMode = UITextFieldViewModeAlways;
    int cellWidth ;
    isClicked = true;
    [self.btnDropDown addTarget:self action:@selector(dropDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc] init];
    self.strUserId = [CommonMethods accessUserDefaultsWithKey:kUserId];

    
        layout1.minimumLineSpacing =0;
        
        contactCollection=[[UICollectionView alloc] initWithFrame:self.lblNoConnects.frame collectionViewLayout:layout1];
        [contactCollection setDataSource:self];
        [contactCollection setDelegate:self];
        [layout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [contactCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

        [contactCollection registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellWithReuseIdentifier:@"UserProfileCell"];
        
        

        if ([UIScreen mainScreen].bounds.size.width == 375)
        {
            cellWidth =  ([UIScreen mainScreen].bounds.size.width-20)/4;
            
            [layout1 setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            
            [layout1 setItemSize:CGSizeMake(cellWidth,cellWidth)];
            
        }
        else if ([UIScreen mainScreen].bounds.size.width == 320)
        {
            cellWidth = (self.view.frame.size.width-20)/4;
            [layout1 setSectionInset:UIEdgeInsetsMake(0, 0 ,0, 0)];
            [layout1 setItemSize:CGSizeMake(cellWidth,cellWidth)];
            
        }else{
            cellWidth =  ([UIScreen mainScreen].bounds.size.width-20)/4;
            
            [layout1 setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            
            [layout1 setItemSize:CGSizeMake(cellWidth,cellWidth)];
        }
        
        [layout1 setMinimumInteritemSpacing:0];
        [layout1 setMinimumLineSpacing:0];
        [layout1 setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [layout1 setItemSize:CGSizeMake(cellWidth-30,cellWidth+40)];

    
    
    [contactCollection setBackgroundColor:[UIColor clearColor]];
    contactCollection.hidden = NO;
    [self.vwSub addSubview:contactCollection];
    [self.lblNoConnects setHidden:YES];
    arrayUploadImages =[[NSMutableArray alloc]init];

        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:[UIImage imageNamed:@"userPlaceHolder"] forKey:@"image"];
        [dict setObject:@"1" forKey:@"isImage"];
        //[arrayUploadImages addObject:dict];
        
    self.imgUser.userInteractionEnabled = YES;
    UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCoverImage)];
    
    [oneTouch setNumberOfTouchesRequired:1];
    
    [self.imgUser addGestureRecognizer:oneTouch];
    
    UITapGestureRecognizer *oneTouch1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
    
    [oneTouch1 setNumberOfTouchesRequired:1];
    //[self.view addGestureRecognizer:oneTouch1];

    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton addTarget:self action:@selector(showPopover:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.frame = CGRectMake(10,410, 300, 30);
    [bottomButton setTitle:@"single" forState:UIControlStateNormal];
    bottomButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.txtInterst addSubview:bottomButton];
    

}
-(void)resignKeyBoard{
    [self.txtInterst resignFirstResponder];
    [self.txtDesignation resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"my id =%@, frnd id=%@",[CommonMethods accessUserDefaultsWithKey:kUserId],self.strUserId);
    self.strUserId = [CommonMethods accessUserDefaultsWithKey:kUserId];
    
    SingleTonClasses *data = [SingleTonClasses sharedManager];
    [data getInterestDefaults];
    NSArray *array = [[NSArray alloc]initWithArray:data.interstArray];
    if([[array objectAtIndex:0] valueForKey:@"Message"] != nil) {
        // The key existed...
        NSLog(@"%@",array[0]);

    }
    else {
        // No joy...
        NSLog(@"%@",array[0]);
        arrayCat =[[NSMutableArray alloc]initWithArray:array];
    }

    if (isClicked)
    {
        [self GetUserProfileData];

    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.btnDropDown setSelected:false];

    if ([self.txtDesignation.text isEqualToString:lastDesignation])
    {
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:true];

        NSMutableDictionary *param=[NSMutableDictionary new];
        [param setValue:@"editprofile_byuser" forKey:@"action"];
        [param setValue:[CommonMethods accessUserDefaultsWithKey:kUserId] forKey:@"userid"];
        [param setValue:self.txtDesignation.text forKey:@"designation"];
        
        [self uploadImageOnServerWithImage:nil andWithImageKey:nil withParam:param];
    }
   
    
}
#pragma mark
#pragma mark UIButton Methods
#pragma mark

-(IBAction)settingButtonClick:(id)sender{
    SettingsVC *connect =[self.storyboard instantiateViewControllerWithIdentifier:@"setting_view"];
    
    [self.navigationController pushViewController:connect animated:YES];
}
-(IBAction)OpnProfileBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)designationButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (!btn.isSelected)
    {
        self.txtInterst.enabled = NO;
        self.txtDesignation.enabled = YES;
        [btn setSelected:YES];

    }else{
        self.txtInterst.enabled = NO;
        self.txtDesignation.enabled = NO;
        [btn setSelected:NO];


    }
}
-(IBAction)interstButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (!btn.isSelected)
    {
        self.txtInterst.enabled = YES;
        self.txtDesignation.enabled = NO;
        [btn setSelected:YES];
        
    }else{
        self.txtInterst.enabled = NO;
        self.txtDesignation.enabled = NO;
        [btn setSelected:NO];
        
        
    }
    
}
-(IBAction)dropDownButtonClick:(id)sender
{
    if (!self.btnDropDown.isSelected)
    {
        //

        //[self showPopover:self forEvent:UIEventTypeTouches];
        [self.btnDropDown setSelected:YES];
        
    }else{
        

        [self.btnDropDown setSelected:NO];
    }


}
-(IBAction)updateProfileButtonClick:(id)sender
{
       // [self sentImage:param];
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setValue:@"editprofile_byuser" forKey:@"action"];
    [param setValue:[CommonMethods accessUserDefaultsWithKey:kUserId] forKey:@"userid"];
    [param setValue:[userDict objectForKey:@"email"] forKey:@"email"];
    [param setValue:[userDict objectForKey:@"name"] forKey:@"name"];
    
    [param setValue:self.txtDesignation.text forKey:@"designation"];
}
#pragma mark
#pragma mark Custom Methods
#pragma mark

-(void)sendRequestToWeb
{
    APIMaster *apimaster = [[APIMaster alloc]init];
    apimaster.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [apimaster sendRequestToWebWithInputStr:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=get_all_info_byuser&userid=%@",[CommonMethods accessUserDefaultsWithKey:kUserId]]];
    
}

-(void)responseFromWeb:(id)response
{
    NSLog(@"response>> %@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([[response objectForKey:@"status"]boolValue])
    {
        if ([[response allKeys] containsObject:@"data"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"No User Available."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        else{
            [self performSelectorOnMainThread:@selector(updateUserData:) withObject:response waitUntilDone:NO];
        }
       
    }
    
}

-(void)updateUserData:(id)dict{
    
    NSArray *arrProfile =[dict objectForKey:@"userprofile"];
//    NSLog(@"%@",arrProfile[0]);
    NSArray *arrConnects =[dict objectForKey:@"connect"];
//    NSLog(@"%@",arrConnects[0]);
  
    if (arrConnects.count > 0)
    {
        [self.lblNoConnects setHidden:YES];
        [contactCollection setHidden:NO];
        arrayConnects = [[NSMutableArray alloc]initWithArray:arrConnects];
        [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }else{
        [self.lblNoConnects setHidden:YES];
        self.lblNoConnects.text  = @"NO CONNECTS";
        [contactCollection setHidden:NO];
        [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

    }
    self.lblUsername.text = [[arrProfile[0] valueForKey:@"name"]capitalizedString];
    userDict =[NSDictionary dictionaryWithDictionary:arrProfile[0]];
    
    self.lblUserDesiganation.text = [[arrProfile[0] valueForKey:@"designation"]capitalizedString];
    self.txtDesignation.text = [[arrProfile[0] valueForKey:@"designation"]capitalizedString];
    
    lastDesignation =[[arrProfile[0] valueForKey:@"designation"]capitalizedString];
    
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrProfile[0]valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"placeHolderBlank"]];
    
   

    arrayUploadImages =[[NSMutableArray alloc]init];
    
    for (int i= 1; i<=4; i++)
    {
//        UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrProfile[0]valueForKey:[NSString stringWithFormat:@"image%d",i]]]]]];
        NSString *str = [NSString stringWithFormat:@"%@",[arrProfile[0]valueForKey:[NSString stringWithFormat:@"image%d",i]]];
        if (str != nil && ![str isEqualToString:@""] && str != (id)[NSNull null])
        {
            NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
            [dict setObject:str forKey:@"image"];
            [dict setObject:[NSNumber numberWithInt:i] forKey:@"isImage"];
            [arrayUploadImages addObject:dict];
        }
       
    }
    
    
    
    if ([[arrProfile[0] valueForKey:@"isactive"]integerValue] == 1)
    {
        [self.imgOnline setHidden:NO];
    }
    else{
        [self.imgOnline setHidden:YES];
    }
}

#pragma mark
#pragma mark <UICollectionViewDataSource>
#pragma mark

// Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
            if (arrayUploadImages.count < 4)
        {
            return arrayUploadImages.count +1;
        }
        return arrayUploadImages.count;
   }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        UserProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserProfileCell" forIndexPath:indexPath];
        if (indexPath.row == arrayUploadImages.count)
        {
            cell.userUploadImg.image = [UIImage imageNamed:@"addImage"];
            cell.userUploadImg.contentMode = UIViewContentModeCenter;
            [cell.btnCross setHidden:true];
            cell.userUploadImg.layer.borderWidth =0.6f;
            cell.userUploadImg.layer.borderColor = [UIColor lightGrayColor].CGColor;

        }
        else{
           // cell.userUploadImg.image = arrayUploadImages[indexPath.row][@"image"];
            [cell.userUploadImg sd_setImageWithURL:[NSURL URLWithString:arrayUploadImages[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
            [cell.btnCross setHidden:false];
            cell.userUploadImg.contentMode = UIViewContentModeScaleToFill;
            cell.userUploadImg.layer.borderWidth =0.6f;
            cell.userUploadImg.layer.borderColor = [UIColor lightGrayColor].CGColor;



        }
        cell.backgroundColor = [UIColor clearColor];
        
        int cellWidth = (self.view.frame.size.width-20)/4;

        cell.userUploadImg.layer.cornerRadius = (cellWidth - 10)/2;
        cell.userUploadImg.clipsToBounds = YES;

        cell.btnCross.tag = indexPath.row +1;
        [cell.btnCross addTarget:self action:@selector(DeleteImageFromCell:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
       int cellWidth = (self.view.frame.size.width-20)/4;

        return CGSizeMake(cellWidth,cellWidth);

}
-(void)DeleteImageFromCell:(UIButton*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%ld",(long)btn.tag);
  
    NSString *fileName;

    if (arrayUploadImages[btn.tag-1][@"image"] != nil && ![arrayUploadImages[btn.tag-1][@"image"] isEqualToString:@""])
    {
         fileName =[NSString stringWithFormat:@"image%d",[arrayUploadImages[btn.tag-1][@"isImage"]intValue]];

    }
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"57f4c474-3a0a-e258-61c7-abc75468e3f2" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=delete_field&userid=%@&fieldname=%@",[CommonMethods accessUserDefaultsWithKey:kUserId],fileName]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:50.0];
    [request setHTTPMethod:@"GET"];
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
                                                        
                                                        NSArray *array = [json valueForKey:@"data"];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            isClicked = true;
                                                            [self viewWillAppear:true];
                                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[array[0] valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                            [alert show];
                                                        });

                                                        
                                                        
                                                                       }
                                                }];
    [dataTask resume];
    
//    [arrayUploadImages removeObjectAtIndex:btn.tag-1];
//    [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}
-(void)uploadImageFromgallery:(UITapGestureRecognizer *)gesture{
    NSLog(@"%ld", gesture.view.tag);
}
#pragma mark
#pragma mark <UICollectionViewDelegate>
#pragma mark

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
         if (indexPath.row == arrayUploadImages.count)
        {
            lastTag = indexPath.row;
            isBigImage = false;
            [self resignKeyBoard];
            [self chooseImageFromGallery];
       }
        else{
        }

        
}

-(void)chooseImageFromGallery{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  
                                  
                                  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                    {
                                        isClicked = false;
                                     UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        imagePickerController.allowsEditing =true;
                                        imagePickerController.delegate = self;
                                        [self presentViewController:imagePickerController animated:YES completion:^{}];
                                  }
                                  
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  isClicked = false;

                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = false;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)changeCoverImage{
    [self resignKeyBoard];
    isBigImage = true;
    [self chooseImageFromGallery];
}
#pragma mark
#pragma mark <UIImagePickerControllerDelegate>
#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isClicked = false;

    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];

    NSString *FileName;
    if (isBigImage)
    {
        self.imgUser.image = image;
        FileName = @"image";
        [self dismissViewControllerAnimated:NO completion:^{
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            DZImageEditingController *editingViewController = [DZImageEditingController new];
            editingViewController.image = image;
            editingViewController.overlayView = self.overlayImageView;
            editingViewController.cropRect = self.frameRect;
            editingViewController.delegate = self;
            
            [self presentViewController:editingViewController
                               animated:YES
                             completion:nil];
            return ;
        }];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:true];

        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:@"http://www.jtechappz.co.in/adminpanel/uploads/" forKey:@"image"];


        for (int i =1; i <= arrayUploadImages.count; i++)
        {
            
            if ([arrayUploadImages[i-1][@"isImage"]intValue] != i)
            {
                FileName = [NSString stringWithFormat:@"image%d",i];
                [dict setObject:[NSNumber numberWithInt:i] forKey:@"isImage"];
                break;

            }
        }
        [arrayUploadImages addObject:dict];

              //Or you can get the image url from AssetsLibrary
        [contactCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        NSMutableDictionary *param=[NSMutableDictionary new];
        
        [param setValue:@"editprofile_byuser" forKey:@"action"];
        [param setValue:[CommonMethods accessUserDefaultsWithKey:kUserId] forKey:@"userid"];
        
          [self uploadImageOnServerWithImage:image andWithImageKey:FileName withParam:param];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - DZImageEditingControllerDelegate

- (void)imageEditingControllerDidCancel:(DZImageEditingController *)editingController
{
    [editingController dismissViewControllerAnimated:YES
                                          completion:nil];
}

- (void)imageEditingController:(DZImageEditingController *)editingController
     didFinishEditingWithImage:(UIImage *)editedImage
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];

    [self.imgUser setImage:editedImage];
    
    NSMutableDictionary *param=[NSMutableDictionary new];
    
    [param setValue:@"editprofile_byuser" forKey:@"action"];
    [param setValue:[CommonMethods accessUserDefaultsWithKey:kUserId] forKey:@"userid"];
    
    [self uploadImageOnServerWithImage:editedImage andWithImageKey:@"image" withParam:param];
    
    [editingController dismissViewControllerAnimated:YES
                                          completion:nil];
}

#pragma mark - private

- (UIImageView *)createOverlayImageViewWithImage:(UIImage *)image
{
    CGFloat newX = [UIScreen mainScreen].bounds.size.width / 2 - image.size.width / 2;
    CGFloat newY = [UIScreen mainScreen].bounds.size.height / 2 - image.size.height / 2;
    newX =0;
    newY = 100;
   // self.frameRect = CGRectMake(newX, newY, image.size.width, image.size.height);
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = (width/8)*5;
    self.frameRect = CGRectMake(newX, newY, width, height);
    return [[UIImageView alloc] initWithFrame:self.frameRect];
}

#pragma mark
#pragma mark <UITextFieldDelegate>
#pragma mark

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == self.txtInterst)
    {
//        [self.btnDropDown setSelected:false];
//        [self dropDownButtonClick:nil];
        UITextField *txt =(UITextField*)textField;
        [self showPopover:txt forEvent:UIEventTypeTouches];

        return false;
    }
    return true;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtInterst)
    {
        [UIView beginAnimations:@"Move Container Up" context:Nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationsEnabled:YES];
        [self.view setFrame:CGRectMake(0,-120,kWindowWidth,kWindowHeight)];
        [UIView commitAnimations];
    }
    else if (textField == self.txtDesignation){
        [UIView beginAnimations:@"Move Container Up" context:Nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationsEnabled:YES];
        [self.view setFrame:CGRectMake(0,-60,kWindowWidth,kWindowHeight)];
        [UIView commitAnimations];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
        [UIView beginAnimations:@"Move Container Down" context:Nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationsEnabled:YES];
        [self.view setFrame:CGRectMake(0, 0,kWindowWidth,kWindowHeight)];
        [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];

    if (textField == self.txtInterst)
    {
        [arrayCat addObject:self.txtInterst.text];
    }
    
    if (textField == self.txtDesignation) {
        [self.txtDesignation resignFirstResponder];
    }
    
    return NO;
}


#pragma mark
#pragma mark UITableView Delegate Methods
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCat.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[arrayCat[indexPath.row][@"name"] capitalizedString]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.txtInterst.text = [NSString stringWithFormat:@"%@",arrayCat[indexPath.row][@"name"]];
    [self.popView dismissPopoverAnimatd:YES];
    [self.btnDropDown setSelected:false];
    [tableView reloadData];
    [tableView setContentOffset:CGPointZero animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark
#pragma mark UITSPopoverController Methods
#pragma mark

-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    [self resignKeyBoard];
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake((self.view.frame.size.width-200)/2,0, 200, 300);
    tableViewController.tableView.delegate = self;
    tableViewController.tableView.dataSource = self;
    [tableViewController.tableView reloadData];
    
    _popView = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    _popView.cornerRadius = 5;
    _popView.titleText = @"CHOOSE INTEREST";
    _popView.popoverBaseColor = [UIColor colorWithRed:41/255.0f green:32/255.0f blue:76/255.0f alpha:1];
    _popView.popoverGradient= NO;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [_popView showPopoverWithTouch:event];
    
}



#pragma mark
#pragma mark MultiPartRequest Methods
#pragma mark

-(void)uploadImageOnServerWithImage:(UIImage*)image andWithImageKey:(NSString*)name withParam:(NSDictionary*)paramData{
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://www.jtechappz.co.in/adminpanel/webservice.php"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:500];
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
    // add image
    NSData *imageCoverData = UIImageJPEGRepresentation(image, 1.0);
    if (imageCoverData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpeg\"",name] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageCoverData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
                                                        
                                                        NSArray *dict = [json valueForKey:@"data"];
                                                        
                                                        NSLog(@"%@",[dict valueForKey:@"Message" ]);
                                                        
                                                        
                                                        if ([[json objectForKey:@"status"]boolValue]) {
                                                            
                                                            NSArray *array =[json valueForKey:@"data"];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                               
                                                                if ([self.txtDesignation.text isEqualToString:lastDesignation])
                                                                {
                                                                    isClicked = true;
                                                                    [self viewWillAppear:true];
                                                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[dict[0] valueForKey:@"Message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                    alert.tag = 1111;
                                                                    [alert show];
 
                                                                }
                                                                
                                                            });


                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                
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
#pragma mark UIAlertView Delegate Methods
#pragma mark

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (alertView.tag == 1111)
    {
        if (buttonIndex == 0)
        {
            
        }
    }
    
}

-(void)GetUserProfileData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"2dbbef37-e036-5d03-06f9-2e95c3f1245e" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.jtechappz.co.in/adminpanel/webservice.php?action=get_all_info_byuser&userid=%@",self.strUserId]]
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:100.0];
    [request setHTTPMethod:@"GET"];
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
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            [self performSelectorOnMainThread:@selector(updateUserData:) withObject:json waitUntilDone:NO];
                                                            
                                                        });
                                                        
                                                    }
                                                }];
    [dataTask resume];
}





@end
