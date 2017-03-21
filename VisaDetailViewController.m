//
//  VisaDetailViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 23/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "VisaDetailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "HowToApplyViewController.h"
#import "PackageDescriptionViewController.h"

@interface VisaDetailViewController ()
{
    NSMutableDictionary *howToApplyDict;
    NSString *strDocument, *strDescription, *strTerms;
}
@end

@implementation VisaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentControlHeightConstant.constant = 50.0f;
    [self setCardViewForButton:self.segmentControl];
    howToApplyDict = [[NSMutableDictionary alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchVisaPackageDetail];
    
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSDictionary *dict = howToApplyDict;
        HowToApplyViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOW_TO_APPLY"];
        vc.dataDict = dict;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        
        [self.containerView addSubview:vc.view];

        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setCardViewForButton :(UISegmentedControl *)segmentControl {
    
    segmentControl.layer.masksToBounds = NO;
    segmentControl.layer.cornerRadius = 3; // if you like rounded corners
    segmentControl.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
    segmentControl.layer.shadowRadius = 1;
    
    segmentControl.layer.shadowOpacity = 0.9;
    //  button.layer.shadowColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;
    
    segmentControl.layer.shadowColor = [UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:segmentControl.bounds];
    self.view.layer.shadowPath = path.CGPath;
       
}

- (IBAction)selectedSegmentControl:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
       
        NSDictionary *dict = howToApplyDict;
        HowToApplyViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOW_TO_APPLY"];
        vc.dataDict = dict;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        
        [self.containerView addSubview:vc.view];
    }
    
    else {
        
        PackageDescriptionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PACKAGE_DESCRIPTION"];
        if (self.segmentControl.selectedSegmentIndex == 1) {
            vc.strToDisplay = strDocument;
        }
        else if (self.segmentControl.selectedSegmentIndex == 2) {
            vc.strToDisplay = strDescription;
        }
        else if (self.segmentControl.selectedSegmentIndex == 3) {
            vc.strToDisplay = strTerms;
        }
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
       
        [self.containerView addSubview:vc.view];
    }
}

#pragma - Mark Consume Webservices methods

-(void) fetchVisaPackageDetail {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_VISAURL,VISA_PACKAGE_DETAIL,_strVisaPackageID] );
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_VISAURL,VISA_PACKAGE_DETAIL,_strVisaPackageID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self parseDataResponseObject:responseArr];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
}


-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
  
        NSDictionary *dataDict = [[[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"] objectAtIndex:0];
        NSLog(@"-------->> %@", dataDict);
        
        //FETCH HOW TO APPLY PAGE DICTIONARY
        NSArray *ary1= [[NSArray alloc]initWithObjects:[dataDict objectForKey:@"HowToApply"] , nil];
        [howToApplyDict setObject:ary1 forKey:@"How To Apply"];
        
        NSArray *ary2= [[NSArray alloc]initWithObjects:[dataDict objectForKey:@"SpecialNotes"] , nil];
        [howToApplyDict setObject:ary2 forKey:@"Special Notes"];
        
        NSArray *ary3= [[NSArray alloc]initWithObjects:[dataDict objectForKey:@"Rates"] , nil];
        [howToApplyDict setObject:ary3 forKey:@"Rates"];
    
    //FETCH DOCUMENT SCREEN DATA
        strDocument = [dataDict objectForKey:@"Documentation"];
        
    //FETCH DESCRIPTION SCREEN DATA
        strDescription = [dataDict objectForKey:@"Description"];
        
    //FETCH TERMS & CONDITION SCREEN DATA
        strTerms = [dataDict objectForKey:@"TermAndCondition"];
        
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
}


@end
