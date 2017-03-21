//
//  AddTravellerViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 29/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "SCRFTPRequest.h"

@protocol AddTravellerViewControllerDelegate <NSObject>

@required
- (void)getBackFromController:(NSString *)strOtherTravellerName;

@end

@interface AddTravellerViewController : UIViewController <NIDropDownDelegate, UIImagePickerControllerDelegate,SCRFTPRequestDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSString  *fullPath;
    
    NIDropDown *dropDown;
}
-(void)rel;


@property (nonatomic, weak) id<AddTravellerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *txtSpecialRequest;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnHonorifics;
- (IBAction)btnHonorifics:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;
@property (weak, nonatomic) IBOutlet UIView *view10;

@property(strong, nonatomic)NSString *package_id;
@property (weak, nonatomic) IBOutlet UIButton *btnNationality;
- (IBAction)btnSelectFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UIButton *btnPassport;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnDocument1;
@property (weak, nonatomic) IBOutlet UIButton *btnDocument2;
- (IBAction)btnImageStatus:(id)sender;



@property (strong, nonatomic) NSArray *travelerDetailArr;

@end
