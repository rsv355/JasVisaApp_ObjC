//
//  SubmitFeedbackViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "SubmitFeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"

@interface SubmitFeedbackViewController ()

@end

@implementation SubmitFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.txtMessage setPlaceholder:@"Message"];
    self.view1.layer.cornerRadius = 4.0f;
    self.view2.layer.cornerRadius = 4.0f;
    self.view3.layer.cornerRadius = 4.0f;
    self.view4.layer.cornerRadius = 4.0f;
    self.btnSubmitFeedback.layer.cornerRadius = 4.0f;
    
    [self setPlaceholderTintColor:self.txtFirstName WithText:@"Name"];
    
    [self setPlaceholderTintColor:self.txtLastName WithText:@"EmailId"];
    
    [self setPlaceholderTintColor:self.txtPhoneNo WithText:@"Phone No"];
    [self.txtMessage setPlaceholderColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIKeyboard methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - IBAction method

- (IBAction)btnSubmitFeedback:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *strEmail = [self.txtLastName text];
    NSString *strName = [self.txtFirstName text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strMessage = [self.txtMessage text];
    if ([strName length] == 0 || [strEmail length] == 0 ||[strPhone length] == 0 ||[strMessage length] == 0 ) {
        
        [self.view makeToast:@"Please Enter All Fields."];
    }
    else if (strPhone.length <10 || strPhone.length>14) {
        [self.view makeToast:@"Enter valid Phone no."];
    }
    else if (![self validateEmail:strEmail]) {
        [self.view makeToast:@"Enter valid Email Id."];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strEmail,@"Email",
                                strName,@"Name",
                                strPhone,@"Mobile",
                                strMessage,@"Message",
                                nil];
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,SUBMIT_FEEDBACK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *dic1 = responseObject;
            [self parseDataResponse:dic1];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"Please check Internet connectivity."];
        }];
        
    }
    
}

-(void) parseDataResponse:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        self.txtMessage.text = @"";
        self.txtPhoneNo.text = @"";
        self.txtFirstName.text = @"";
        self.txtLastName.text =@"";
    }
    else   {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
    
}
#pragma - mark UITextField Limit method

/* - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField != self.txtLastName) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<50) {
            return YES;
        }
        else
            return NO;
    }
    
    
    else {
        return  YES;
    }
    
    
}*/

-(BOOL) validateEmail:(NSString*) emailString{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    ////NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
}

-(void)setPlaceholderTintColor:(UITextField *)textField WithText:(NSString *)string{
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
}
@end
