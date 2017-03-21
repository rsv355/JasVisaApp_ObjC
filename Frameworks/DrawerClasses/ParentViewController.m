//
//  ParentViewController.m
//  ShreeSwastik
//
//  Created by Developers on 24/09/15.
//  Copyright (c) 2015 ChorusProapp. All rights reserved.
//

#import "ParentViewController.h"
#import "MainContentNavigationController.h"
#import "SearchViewController.h"
#import "VisaListViewController.h"
#import "CommonViewController.h"
#import "LoginViewController.h"

@interface ParentViewController ()<SearchViewControllerDelegate,LoginViewControllerDelegate>
{
    
}

@end

@implementation ParentViewController

- (void)viewDidLoad {
    //[self headerColour];
    [super viewDidLoad];

//    [self.mainContentNavigationController setNavigationRoot:@"HOME"];
 
    VisaListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOME"];
    [self addChildViewController:vc];
     vc.isDelegate = @"0";
    vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
    [self.parentContentContainer addSubview:vc.view];
    [self.lblHeaderTitle setText:@"VISA"];
    [self.btnSearch setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSubContent:(NSString*)storyboardID{
    //NSLog(@"StoryBoard ID for subcontent is %@",storyboardID);
    [self.mainContentNavigationController setNavigationRoot:storyboardID];
    
    if ([storyboardID isEqualToString:@"HOME"]) {
        
        VisaListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
        [self addChildViewController:vc];
        vc.isDelegate = @"0";
        vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
        [self.parentContentContainer addSubview:vc.view];
        [self.lblHeaderTitle setText:@"VISA"];
        [self.btnSearch setHidden:NO];

    }
    else if ([storyboardID isEqualToString:@"PROFILE"]) {
//        [self.btnSearch setHidden:YES];

        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"JAS VISA" message:@"Please login first" delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        else {
            
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    else if ([storyboardID isEqualToString:@"INSTANT_PAY"]) {

        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    else if ([storyboardID isEqualToString:@"ABOUT"])   {
            
        CommonViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"COMMON"];
        [self addChildViewController:vc];
       vc.storyboardID = @"ABOUT";
        vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
        [self.parentContentContainer addSubview:vc.view];
         [self.lblHeaderTitle setText:@"ABOUT US"];
    
    }
    else if ([storyboardID isEqualToString:@"LOGIN"]) {
        
//        [self.btnSearch setHidden:YES];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
            
            LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
            viewController.delegate = (id)self;
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
        else {
            NSLog(@"LOGOUT AND DELETE SESSION OF :: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
            VisaListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOME"];
            [self addChildViewController:vc];
            vc.isDelegate = @"0";
            vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
            [self.parentContentContainer addSubview:vc.view];
             [self.lblHeaderTitle setText:@"VISA"];
        }

    }
    else if ([storyboardID isEqualToString:@"SUBMIT_FEEDBACK"]) {
        [self.lblHeaderTitle setText:@"SUBMIT FEEDBACK"];
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
        [self.parentContentContainer addSubview:vc.view];
    }
    else if ([storyboardID isEqualToString:@"CART"]) {
        [self.lblHeaderTitle setText:@"MY CART"];
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
        [self.parentContentContainer addSubview:vc.view];

    }
    
    else {
         [self.btnSearch setHidden:YES];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"JAS VISA" message:@"Please login first" delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    
        else {
             if ([storyboardID isEqualToString:@"CONTACT_US"]) {
                [self.lblHeaderTitle setText:@"CONTACT US"];
            }
                        else if ([storyboardID isEqualToString:@"BOOKING_HISTORY"]) {
                [self.lblHeaderTitle setText:@"BOOKING HISTORY"];
            }
            
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
            [self addChildViewController:vc];
            
            vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
            [self.parentContentContainer addSubview:vc.view];
        }
        
    }
    

}

- (IBAction)btnSearch:(id)sender {
    
    SearchViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH"];
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}


-(void)getFromSearchControllerFor:(NSString *)visaForID nationality:(NSString *)nationalityID travelDate:(NSString *)date visaType:(NSString *)visaTypeID {
    
    NSLog(@"%@--%@---%@---%@",visaForID,nationalityID,date,visaTypeID);
    VisaListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOME"];
    [self addChildViewController:vc];
    vc.isDelegate = @"1";
    vc.strCountryID = visaForID;
    vc.strNationalityID = nationalityID;
    vc.strTravelDate = date;
    vc.strVisaTypeID =visaTypeID;
    vc.view.frame = CGRectMake(0, 0, self.parentContentContainer.frame.size.width, self.parentContentContainer.frame.size.height);
    [self.parentContentContainer addSubview:vc.view];
    [self.lblHeaderTitle setText:@"SEARCH RESULT"];
     [self.btnSearch setHidden:NO];
}

-(void)getFromLoginController:(NSString *)userID {
    
    NSLog(@"LOGIN ID ------ %@",userID);
}

@end
