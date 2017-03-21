//
//  ProfileViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 29/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIButton+tintImage.h"
#import "UITextView+Placeholder.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "DataBaseFile.h"
#import "LoginViewController.h"

@interface ProfileViewController () <LoginViewControllerDelegate>
{
    NSString *strNationalityID;
    NSMutableArray *nationalityArr,*nationalityName;
    NSString *strUserID;
    NSArray *userArr;
}

@property (strong, nonatomic)DataBaseFile *dbHandler;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbHandler = [[DataBaseFile alloc]init];
    [self.dbHandler CopyDatabaseInDevice];

    [self setLayout];
    strNationalityID = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        NSLog(@"-----------------");
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
        viewController.delegate = (id)self;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    else {
        NSLog(@"CALL SERVICE WITH :: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
        strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        
        [self fetchNationalityDataFromDatabase];
        [self fetchUserDataFromDatabase];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setLayout {
    
    self.viewProfilePic.layer.cornerRadius = 40.0f;
    self.viewProfilePic.layer.borderWidth = 2.0f;
    //self.viewProfilePic.layer.borderColor = [UIColor colorWithRed:(117/255.0) green:(117/255.0) blue:(117/255.0) alpha:1.0f].CGColor;
    self.viewProfilePic.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.btnProfilePicture setImageTintColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnUpdateProfile.layer.cornerRadius = 4.0f;
    self.view1.layer.cornerRadius = 4.0f;
    self.view2.layer.cornerRadius = 4.0f;
    self.view3.layer.cornerRadius = 4.0f;
    self.view4.layer.cornerRadius = 4.0f;
    self.view5.layer.cornerRadius = 4.0f;
    self.view6.layer.cornerRadius = 4.0f;
    self.view7.layer.cornerRadius = 4.0f;
    self.view8.layer.cornerRadius = 4.0f;
    self.view9.layer.cornerRadius = 4.0f;
    self.btnHonorifics.layer.cornerRadius = 4.0f;
    [self setPlaceholderTintColor:self.txtFirstName WithText:@"First Name"];
    [self setPlaceholderTintColor:self.txtLastName WithText:@"Last Name"];
    [self setPlaceholderTintColor:self.txtEmailId WithText:@"Email Id"];
    [self setPlaceholderTintColor:self.txtCountryCode WithText:@"Code"];
    [self setPlaceholderTintColor:self.txtPhoneNo WithText:@"Phone No"];
    [self setPlaceholderTintColor:self.txtAddress WithText:@"Address"];
    [self setPlaceholderTintColor:self.txtCity WithText:@"City"];
    [self setPlaceholderTintColor:self.txtState WithText:@"State"];
    [self setPlaceholderTintColor:self.txtPincode WithText:@"Pincode"];
    [self setCardViewForButton:self.btnSelectNationality];

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
-(void)setCardViewForButton :(UIButton *)button {
    
    button.layer.masksToBounds = NO;
    button.layer.cornerRadius = 3; // if you like rounded corners
    button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    button.layer.shadowRadius = 1;
    
    button.layer.shadowOpacity = 0.7;
    //  button.layer.shadowColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;
    
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:button.bounds];
    button.imageView.layer.shadowPath = path.CGPath;
    
}
#pragma mark -  Fetch data from database

-(void)fetchNationalityDataFromDatabase {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from nationality_master"];
    nationalityArr = [[NSMutableArray alloc]init];
    nationalityName = [[NSMutableArray alloc]init];
    
    nationalityArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:3];
    for (int i = 0; i<[nationalityArr count]; i++) {
        [nationalityName addObject:[[nationalityArr objectAtIndex:i] objectAtIndex:1]];
    }
    
}
-(void)fetchUserDataFromDatabase {
    
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from user where userID = '%@'",strUserID];
    
    userArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:16];
    
    NSLog(@"USER ARRAY -- >> %@",userArr);
    
    if ([userArr count] != 0) {
        //set all data
       
        [self.txtFirstName setText:[[userArr objectAtIndex:0] objectAtIndex:2]];
        [self.txtLastName setText:[[userArr objectAtIndex:0] objectAtIndex:3]];
        [self.txtEmailId setText:[[userArr objectAtIndex:0] objectAtIndex:4]];
        [self.txtCountryCode setText:@""];
        [self.txtPhoneNo setText:[[userArr objectAtIndex:0] objectAtIndex:5]];
        [self.txtAddress setText:[[userArr objectAtIndex:0] objectAtIndex:6]];
        [self.txtCity setText:[[userArr objectAtIndex:0] objectAtIndex:7]];
        [self.txtState setText:[[userArr objectAtIndex:0] objectAtIndex:10]];
        [self.txtPincode setText:[[userArr objectAtIndex:0] objectAtIndex:8]];
        if ([[[userArr objectAtIndex:0] objectAtIndex:1] length] !=0) {
           
            [self.btnHonorifics setTitle:[[userArr objectAtIndex:0] objectAtIndex:1] forState:UIControlStateNormal];
        }
        if ([[[userArr objectAtIndex:0] objectAtIndex:9] length] == 0) {
            strNationalityID = @"0";
        }
        else {
        
            for (int i = 0; i<[nationalityArr count]; i++) {
            
                if ([[[nationalityArr objectAtIndex:i] objectAtIndex:0] isEqualToString:[[userArr objectAtIndex:0] objectAtIndex:9]]) {
                    NSLog(@"--> %@",[[nationalityArr objectAtIndex:i] objectAtIndex:1]);
                    strNationalityID = [[userArr objectAtIndex:0] objectAtIndex:9];
                    [self.btnSelectNationality setTitle:[[nationalityArr objectAtIndex:i] objectAtIndex:1] forState:UIControlStateNormal];
                }
            }
        }
    }
}



#pragma mark - UIButton IBAction

- (IBAction)btnProfilePicture:(id)sender {
    
}


- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUpdateProfile:(id)sender {
    
    NSString *strFirstName = [self.txtFirstName text];
    NSString *strLastName = [self.txtLastName text];
    NSString *strEmailId = [self.txtEmailId text];
    NSString *strCountryCode = [self.txtCountryCode text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strAddress = [self.txtAddress text];
    NSString *strCity = [self.txtCity text];
    NSString *strState = [self.txtState text];
    NSString *strPincode = [self.txtPincode text];
    
    if ([strFirstName length] == 0 || [strLastName length] == 0 || [strEmailId length] == 0 || [strCountryCode length] == 0 || [strPhone length] == 0 || [strAddress length] == 0 || [strCity length] == 0 || [strState length] == 0 || [strPincode length] == 0) {
        
        [self.view makeToast:@"Please enter all fields."];
    }
    else if (![self validateEmail:strEmailId]) {
        
        [self.view makeToast:@"Please enter valid Email Id."];
    }
    else if ([strPincode length] != 6) {
        
        [self.view makeToast:@"Enter valid zipcode."];
    }
    else if ([strPhone length] < 10 || [strPhone length] > 14) {
        
        [self.view makeToast:@"Enter valid Phone no."];
    }
    else if([strNationalityID integerValue] == 0) {
        
        [self.view makeToast:@"Please  select nationality."];
    }
    else {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strAddress,@"Address",
                                strCity,@"City",
                                strCountryCode,@"CountryCode",
                                strNationalityID,@"CountryID",
                                strFirstName,@"FName",
                                strLastName,@"LName",
                                strPhone,@"MobileNo",
                                @"",@"Password",
                                @"",@"ProfilePic",
                                strState,@"State",
                                strUserID,@"UserID",
                                strPincode,@"ZipCode",
                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,UPDATE_USER_PROFILE]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,UPDATE_USER_PROFILE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
- (IBAction)btnHonorifics:(id)sender {
    
    
}

- (IBAction)btnSelectNationality:(id)sender {
    
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :nationalityName :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}
#pragma mark -  NIDropDown Delegate methods

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self rel];
}

-(void) selectedIndex:(NSInteger)selectedIndex {
    
    strNationalityID = [[nationalityArr objectAtIndex:selectedIndex] objectAtIndex:0];
}

-(void)rel{
    
    dropDown = nil;
}

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField != self.txtEmailId && textField != self.txtCountryCode) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<50) {
            return YES;
        }
        else
            return NO;
    }
    else if (textField == self.txtCountryCode) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<4) {
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

#pragma  mark - UIViewController Delegate methods

-(void)getFromLoginController:(NSString *)userID {
    
    NSLog(@"PROFILE USERID -->>> %@",userID);
    [self viewDidLoad];
}

#pragma - mark Parse JSON Response methods

-(void) parseDataResponse:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        
        NSString *updateQuery = [NSString stringWithFormat:@"update user set title='%@',firstName='%@',lastName='%@',email='%@',mobile='%@',address='%@',city='%@',nationality='%@',state='%@', profilepic='%@'  where userID='%@'",[self.btnHonorifics titleForState:UIControlStateNormal], [self.txtFirstName text], [self.txtLastName text], [self.txtEmailId text], [self.txtPhoneNo text], [self.txtAddress text], [self.txtCity text], [self.txtPincode text],strNationalityID, [self.txtState text],strUserID];
        NSLog(@"--->> %@",updateQuery);
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
         [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
}
@end
