//
//  InstantPayViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "InstantPayViewController.h"
#import "UITextView+Placeholder.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "DataBaseFile.h"

@interface InstantPayViewController ()
{
    NSString *strNationalityID;
    NSMutableArray *nationalityArr,*nationalityName;
}

@property(strong,nonatomic)DataBaseFile *dbHandler;
@end

@implementation InstantPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self setPlaceholders];
    [self setViewLayout];
    
    [self.txtAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self fetchNationalityDataFromDatabase];
    strNationalityID = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setViewLayout {
    
    self.view1.layer.cornerRadius = 4.0f;
    self.view2.layer.cornerRadius = 4.0f;
    self.view3.layer.cornerRadius = 4.0f;
    self.view4.layer.cornerRadius = 4.0f;
    self.view5.layer.cornerRadius = 4.0f;
    self.view6.layer.cornerRadius = 4.0f;
    self.view7.layer.cornerRadius = 4.0f;
    self.view8.layer.cornerRadius = 4.0f;
    self.view9.layer.cornerRadius = 4.0f;
    self.view10.layer.cornerRadius = 4.0f;
    self.btnPayNow.layer.cornerRadius = 4.0f;
    
}

-(void) setPlaceholders {
    
    [self.txtBillingAddress setPlaceholderColor:[UIColor grayColor]];
    [self setPlaceholderTintColor:self.txtAmount WithText:@"Amount"];
    [self setPlaceholderTintColor:self.txtBillingName WithText:@"Billing Name"];
    [self setPlaceholderTintColor:self.txtCityName WithText:@"City Name"];
    [self setPlaceholderTintColor:self.txtZipcode WithText:@"Zipcode"];
    [self setPlaceholderTintColor:self.txtPhoneNo WithText:@"Phone No"];
    [self setPlaceholderTintColor:self.txtEmailId WithText:@"Email Id"];
    [self setPlaceholderTintColor:self.txtConfirmEmailId WithText:@"Confirm Email Id"];
    [self.txtBillingAddress setPlaceholder:@"Billing Address"];
    [self setCardViewForButton:self.btnNationality];
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

#pragma - mark setlayout
- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - IBAction methods

- (IBAction)btnPayNow:(id)sender {
   
    
    [self.view endEditing:YES];
    
    NSString *strAmount = [self.txtAmount text];
    NSString *strTotalAmount = [self.txtTotalAmount text];
    NSString *strBillingName = [self.txtBillingName text];
    NSString *strBillingAddress = [self.txtBillingAddress text];
    NSString *strCityName = [self.txtCityName text];
    NSString *strZipCode = [self.txtZipcode text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strCountryCode = [self.txtCountryCode text];
    NSString *strEmail = [self.txtEmailId text];
    NSString *strConfirmEmail = [self.txtConfirmEmailId text];
    

    if ([strAmount length] == 0 || [strTotalAmount length] == 0 || [strBillingName length] == 0 || [strBillingAddress length] == 0 || [strCityName length] == 0 || [strZipCode length] == 0 || [strPhone length] == 0 || [strEmail length] == 0 || [strConfirmEmail length] == 0 ) {
        
        [self.view makeToast:@"Please enter all fields."];
    }
    else if (![self validateEmail:strEmail] || ![self validateEmail:strConfirmEmail]) {
        
        [self.view makeToast:@"Please enter valid Email Id."];
    }
    else if ([strZipCode length] != 6) {
        
        [self.view makeToast:@"Enter valid zipcode."];
    }
    else if ([strPhone length] < 10 || [strPhone length] > 14) {
        
        [self.view makeToast:@"Enter valid Phone no."];
    }
    else if(![strEmail isEqualToString:strConfirmEmail]) {
        
        [self.view makeToast:@"Email Id does not match."];
    }
    else if([strNationalityID integerValue] == 0) {
        
        [self.view makeToast:@"Please  select nationality."];
    }
    else {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strBillingAddress,@"Address",
                                strAmount,@"Amount",
                                strCityName,@"City",
                                strCountryCode,@"CountryCode",
                                strEmail,@"Email",
                                [NSNumber numberWithBool:1],@"IsPayuSuccess",
                                @"123456",@"JASTransactionID",
                                @"123456",@"Mihpayid",
                                strPhone,@"Mobile",
                                strBillingName,@"Name",
                                strNationalityID,@"NationalityID",
                                [NSNumber numberWithFloat:DEFAULT_SURCHARGE],@"SurChargePer",
                                strTotalAmount,@"TotalAmount",
                                strZipCode,@"Zipcode",
                                
                                nil];
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,INSTANT_PAY]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,INSTANT_PAY] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
    
    [self clearTexts];
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        
    }
    else   {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
    
}

- (IBAction)btnNationality:(id)sender {
    
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


#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField != self.txtEmailId && textField != self.txtConfirmEmailId && textField != self.txtCountryCode) {
        
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

-(void)textFieldDidChange :(UITextField *)theTextField{
   
    if (self.txtAmount.editing == NO) {
        NSLog(@"NO");
    }
    else if (self.txtAmount.editing == YES) {
        
        NSString *strAmount = [self.txtAmount text];
        float amount = [strAmount floatValue];
        float totalamount = amount + (amount * (DEFAULT_SURCHARGE/100));
        self.txtTotalAmount.text = [NSString stringWithFormat:@"%.2f",totalamount];
    }
    
}

-(void)clearTexts {
    self.txtAmount.text = @"";
    self.txtTotalAmount.text = @"";
    self.txtBillingName.text = @"";
    self.txtBillingAddress.text = @"";
    self.txtCityName.text = @"";
    self.txtZipcode.text = @"";
    self.txtPhoneNo.text = @"";
    self.txtEmailId.text = @"";
    self.txtConfirmEmailId.text = @"";
    strNationalityID= @"0";
    [self.btnNationality setTitle:@"Select Nationality" forState:UIControlStateNormal];
}

//------

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField

{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 0, 320, 40)];
    
    keyboardToolBar.barStyle = UIBarStyleBlackOpaque;
    [keyboardToolBar setTintColor:[UIColor whiteColor]];
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

-(void)resignKeyboard {
    
    [self.view endEditing:YES];
}
@end
