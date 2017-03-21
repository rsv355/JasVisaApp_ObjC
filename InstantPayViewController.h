//
//  InstantPayViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface InstantPayViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}
-(void)rel;

@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtBillingName;
@property (weak, nonatomic) IBOutlet UITextView *txtBillingAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCityName;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmEmailId;
@property (weak, nonatomic) IBOutlet UIButton *btnNationality;
@property (weak, nonatomic) IBOutlet UIButton *btnPayNow;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryCode;

- (IBAction)btnPayNow:(id)sender;
- (IBAction)btnNationality:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *view10;

@end
