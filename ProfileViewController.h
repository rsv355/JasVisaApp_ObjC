//
//  ProfileViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 29/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface ProfileViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}
-(void)rel;

@property (weak, nonatomic) IBOutlet UIView *viewProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePicture;
- (IBAction)btnProfilePicture:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtPincode;

@property (weak, nonatomic) IBOutlet UIButton *btnHonorifics;
- (IBAction)btnHonorifics:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectNationality;
- (IBAction)btnSelectNationality:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateProfile;
- (IBAction)btnUpdateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
