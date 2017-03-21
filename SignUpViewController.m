//
//  SignUpViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "CommonViewController.h"

@interface SignUpViewController ()
{
    NSString *strChecked1, *strChecked2;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPlaceholderTintColor:self.txtFirstName WithText:@"First Name"];
    [self setPlaceholderTintColor:self.txtLastName WithText:@"Last Name"];
    [self setPlaceholderTintColor:self.txtPhoneNo WithText:@"Phone No"];
    [self setPlaceholderTintColor:self.txtEmailId WithText:@"Email Id"];
    [self setPlaceholderTintColor:self.txtPassword WithText:@"Password"];
    [self setPlaceholderTintColor:self.txtConfirmPassword WithText:@"Confirm Password"];
    
    _btnCheckbox1.layer.borderWidth = 2.0f;
    _btnCheckbox1.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnCheckbox2.layer.borderWidth = 2.0f;
    _btnCheckbox2.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnSingUp.layer.cornerRadius = 4.0f;
    
    
    self.view1.layer.cornerRadius = 4.0f;
    self.view2.layer.cornerRadius = 4.0f;
    self.view3.layer.cornerRadius = 4.0f;
    self.view4.layer.cornerRadius = 4.0f;
    self.view5.layer.cornerRadius = 4.0f;
    self.view6.layer.cornerRadius = 4.0f;
    self.view7.layer.cornerRadius = 4.0f;
    strChecked1 = @"0";
    strChecked2 = @"0";

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

-(void)setPlaceholderTintColor:(UITextField *)textField WithText:(NSString *)string{
   
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];

}

- (IBAction)btnCheckBox:(id)sender {

    if ([sender tag] == 1) {
        if ([strChecked1 integerValue] == 0) {
            strChecked1 = @"1";
            [self.btnCheckbox1 setImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        }
        else if ([strChecked1 integerValue] == 1) {
            strChecked1 = @"0";
            [self.btnCheckbox1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
    else if ([sender tag] == 2) {
       
        if ([strChecked2 integerValue] == 0) {
            strChecked2 = @"1";
            [self.btnCheckbox2 setImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        }
        else if ([strChecked2 integerValue] == 1) {
            strChecked2 = @"0";
            [self.btnCheckbox2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }

}


- (IBAction)btnSignUp:(id)sender {
    NSString *strFirstName =[self.txtFirstName text];
    NSString *strLastName = [self.txtLastName text];
    NSString *strPhoneNo = [self.txtPhoneNo text];
    NSString *strEmailID = [self.txtEmailId text];
    NSString *strPassword = [self.txtPassword text];
    NSString *strRetypePassword = [self.txtConfirmPassword text];
    NSString *strCountryCode = [self.txtPhoneCode text];
    
    if ([strFirstName length] ==0 || [strLastName length] ==0 || [strPhoneNo length] ==0 || [strCountryCode length] ==0 || [strEmailID length] ==0 || [strPassword length] ==0 || [strRetypePassword length] ==0) {
        
        [self.view makeToast:@"Please enter all fields."];
    }
    else if ([strPhoneNo length]<10 || [strPhoneNo length]>14 ) {
        [self.view makeToast:@"Please Enter valid phone no."];
    }
    else if ([strCountryCode length] != 2) {
        [self.view makeToast:@"Please Enter valid Country code."];
    }
    else if (![strPassword isEqualToString:strRetypePassword]) {
        [self.view makeToast:@"Password does not match."];
    }
    else if (![self validateEmail:strEmailID]) {
    
        [self.view makeToast:@"Please Enter valid Email Id."];
    }
    else if ([strChecked2 integerValue] == 0) {
        
        [self.view makeToast:@"Please agree to JasTours T&C for registration"];
    }
    else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strCountryCode,@"CountryCode",
                                strEmailID,@"Email",
                                strFirstName,@"FName",
                                @"",@"FaceBookID",
                                @"",@"GoogleID",
                                strLastName,@"LName",
                                strPhoneNo,@"MobileNo",
                                strPassword,@"Password",
                                [NSNumber numberWithInteger:DEFAULT_SIGNUP_FORM],@"RegistrationByID",
                                nil];
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,USER_RESTRATION]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,USER_RESTRATION] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *dic1 = responseObject;
            NSLog(@"--->>%@",dic1);
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
        
        NSLog(@"--->>%@",dictionary);
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else  {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
    
}


- (IBAction)btnBack:(id)sender {
  
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 // Prevent crashing undo bug – see note below.
 
    if (textField != self.txtEmailId) {
 
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
 
}

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

- (IBAction)btnTermsCondition:(id)sender {
    
    CommonViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"COMMON"];
        vc.storyboardID = @"TERMS";
    [self presentViewController:vc animated:YES completion:nil];
   
}
@end
