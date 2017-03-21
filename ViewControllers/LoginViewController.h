//
//  LoginViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewControllerDelegate <NSObject>

@required
- (void)getFromLoginController:(NSString *)userID;

@end
@interface LoginViewController : UIViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogIn:(id)sender;

- (IBAction)btnForgetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogInWithFacebook;
- (IBAction)btnLogInWithFacebook:(id)sender;
- (IBAction)btnLogInWithGooglePlus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogInWithGooglePlus;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@end
