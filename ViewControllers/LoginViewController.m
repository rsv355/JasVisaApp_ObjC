//
//  LoginViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "DataBaseFile.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
static NSString * const kClientId = @"577953899484-cdl9herr09q5qjukm7n9dcshg11dev1g.apps.googleusercontent.com";

@interface LoginViewController ()
{
    NSString *strIsFromSocial;
}
@property(strong,nonatomic)DataBaseFile *dbHandler;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    self.txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name/Email" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    self.btnLogin.layer.cornerRadius = 4.0f;
    self.btnLogInWithFacebook.layer.cornerRadius = 4.0f;
    self.btnLogInWithGooglePlus.layer.cornerRadius = 4.0f;
    
    self.view1.layer.cornerRadius = 4.0f;
    self.view2.layer.cornerRadius = 4.0f;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
     signIn.shouldFetchGooglePlusUser = YES;
     signIn.clientID = kClientId;
     
     
     signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
     //signIn.scopes = @[ @"profile" ];            // "profile" scope
     
     // Optional: declare signIn.actions, see "app activities"
     signIn.delegate = (id)self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)setViewCard {
    
    
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 1; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.cardView.layer.shadowRadius = 1;
    
    self.cardView.layer.shadowOpacity = 0.8;
    self.cardView.layer.shadowColor = [UIColor  lightGrayColor].CGColor;
    //self.cardView.layer.shadowColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.view.layer.shadowPath = path.CGPath;
}
- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSignUp:(id)sender {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIGN_UP"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnLogIn:(id)sender {
    
    
    strIsFromSocial = @"0";
    
    [self.view endEditing:YES];
    
    NSString *strEmail = [self.txtEmailId text];
    NSString *strPassword = [self.txtPassword text];
    
    if ([strEmail length] == 0 || [strPassword length] == 0) {
        
        [self.view makeToast:@"Please Enter All Fields."];
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
                                strPassword,@"Password",
                                nil];
      
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,USER_LOGIN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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


- (IBAction)btnForgetPassword:(id)sender {
}


- (IBAction)btnLogInWithFacebook:(id)sender {
    
    strIsFromSocial = @"1";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
            
             UIAlertView *errMsg=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [errMsg show];
             
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
            
             UIAlertView *canMsg=[[UIAlertView alloc]initWithTitle:@"Information" message:@"User has cancelled authorization" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [canMsg show];
         } else {
             NSLog(@"Logged in");
             
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 FBSDKGraphRequest *basicRequest=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,friends,email,first_name,last_name,about,birthday"} HTTPMethod:@"GET"];
                 [basicRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     NSLog(@"result%@",result);
                     
                     NSDictionary *dict = (NSDictionary*)result;
                     
                    /*if ([dict objectForKey:@"email"])
                     {
                        
                         NSLog(@"--->>%@",[dict objectForKey:@"email"]);
                        
                     }
                     
                     
                     if ([dict objectForKey:@"first_name"])
                     {
                         
                         NSLog(@"--->>%@",[dict objectForKey:@"first_name"]);
                     }
                     
                     if ([dict objectForKey:@"last_name"])
                     {
                        
                         NSLog(@"--->>%@",[dict objectForKey:@"last_name"]);
                     }*/
                     [self registerWithUserFirstName:[dict objectForKey:@"first_name"] lastName:[dict objectForKey:@"last_name"] userEmailID:[dict objectForKey:@"email"] facebookID:[dict objectForKey:@"id"] googleID:@""];
                     
                     
                     
                 }];
                 
             }
             
         }
     }];
    return;

}

- (IBAction)btnLogInWithGooglePlus:(id)sender {

    strIsFromSocial = @"1";
    
    GPPSignIn *googleSignIn = [GPPSignIn sharedInstance];
    googleSignIn.shouldFetchGooglePlusUser = YES;
    googleSignIn.shouldFetchGoogleUserEmail = YES;
    googleSignIn.clientID = @"577953899484-cdl9herr09q5qjukm7n9dcshg11dev1g.apps.googleusercontent.com";
    googleSignIn.scopes = @[ kGTLAuthScopePlusLogin ];
    googleSignIn.delegate = (id)self;
    
    [googleSignIn authenticate];
    //NSLog(@"---");
}
#pragma mark - Google+ Methods
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        
    }
    else {
    }
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
    if (error) {
               UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alrt show];
        
        
       
    } else {
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        
        
        GTLQueryPlus *query =
        [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                        collection:kGTLPlusCollectionVisible];
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPeopleFeed *peopleFeed,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        
                        
                    }
                }];
        
        GTLQueryPlus *query1 = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query1
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                       
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                        NSLog(@"last name=%@", person.name.familyName);
                        NSLog(@"first name=%@", person.name.givenName);
                        [self registerWithUserFirstName:person.name.givenName lastName:person.name.familyName userEmailID:[GPPSignIn sharedInstance].authentication.userEmail facebookID:@"0" googleID:person.identifier];
        
                    }
                }];
    }
}

-(void)registerWithUserFirstName:(NSString *)firstName lastName:(NSString *)lastName userEmailID:(NSString *)emailId facebookID:(NSString *)facebookId googleID:(NSString *)googleId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"0",@"CountryCode",
                            emailId,@"Email",
                            firstName,@"FName",
                            facebookId,@"FaceBookID",
                            googleId,@"GoogleID",
                            lastName,@"LName",
                            @"",@"MobileNo",
                            @"",@"Password",
                            [NSNumber numberWithInteger:DEFAULT_SIGNUP_SOCIAL],@"RegistrationByID",
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
#pragma - mark Parse JSON Response methods
-(void) parseDataResponse:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        NSLog(@"RESPONSE >> %@",dictionary);
        NSDictionary *userDict = [[[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"] objectAtIndex:0];
        
        NSString *strUserID = [userDict objectForKey:@"UserID"];
        
        [[NSUserDefaults standardUserDefaults]setObject:strUserID forKey:@"userID"];
        
        NSString *strTitle = [userDict objectForKey:@"Title"];
        NSString *strFirstName = [userDict objectForKey:@"FName"];
        NSString *strLastName = [userDict objectForKey:@"LName"];
        NSString *strEmail = [userDict objectForKey:@"Email"];
        NSString *strMobile = [userDict objectForKey:@"MobileNo"];
        NSString *strAddress = [userDict objectForKey:@"Address"];
        NSString *strCity = [userDict objectForKey:@"City"];
        NSString *strPincode = [userDict objectForKey:@"ZipCode"];
        NSString *strNationality = [userDict objectForKey:@"NationalityID"];
        NSString *strState = [userDict objectForKey:@"State"];
        NSString *strSMSAlert = [userDict objectForKey:@"SmsAlert"];
        NSString *strLowfareAlert = [userDict objectForKey:@"LowFareAlert"];
        NSString *strSpecialOfferAlert = [userDict objectForKey:@"SpecialAlert"];
    
        
        NSString *strProfilePic;
        if ([[userDict objectForKey:@"ProfilePic"] length] !=0) {
           
           strProfilePic = [[userDict objectForKey:@"ProfilePicPath"] stringByAppendingString:[userDict objectForKey:@"ProfilePic"]];

        }
        else {
            strProfilePic = @"";
        }
       
        
        NSString *deleteQuery =[NSString stringWithFormat:@"delete from user where userID='%@'",strUserID];
        [self.dbHandler DeleteDataWithQuesy:deleteQuery];
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into user (userID,title, firstName, lastName, email, mobile, address, city, pincode, nationality, state, smsalert, lowfarealert, specialofferalert, profilepic, isfromsocial) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", strUserID,strTitle, strFirstName, strLastName, strEmail, strMobile, strAddress, strCity, strPincode, strNationality, strState, strSMSAlert, strLowfareAlert, strSpecialOfferAlert, strProfilePic, strIsFromSocial];
        NSLog(@"--->>%@",insertQuery);
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_delegate respondsToSelector:@selector(getFromLoginController:)])
        {
            [_delegate getFromLoginController:strUserID];
        }
    }
    else   {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
    
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
@end
