//
//  SubmitFeedbackViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitFeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitFeedback;
- (IBAction)btnSubmitFeedback:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
