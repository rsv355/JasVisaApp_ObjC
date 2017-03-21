//
//  CommonViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "CommonViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "NSString+HTML.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtCommon.text = @"";
    self.lblHeaderTitle.text = @"";
    if ([_storyboardID isEqualToString:@"ABOUT"]) {
        self.btnback.hidden = YES;
        self.lblHeaderTitle.hidden = YES;
        self.viewHeaderHeightConstant.constant = 0.0f;
        [self fetchPageDetail:DEFAULT_ABOUT_US];
    }
    else if ([_storyboardID isEqualToString:@"TERMS"]) {
        self.btnback.hidden = NO;
        self.lblHeaderTitle.hidden = NO;
        self.viewHeaderHeightConstant.constant = 65.0f;
        [self fetchPageDetail:DEFAULT_TERMS_CONDITION];
    }
    else if ([_storyboardID isEqualToString:@"POLICY"]) {
        [self.lblHeaderTitle setText:@"Cancellation Policy"];
       
        NSString *htmlString = _strCommon;
        NSString *str=[htmlString stringByDecodingHTMLEntities];
        
        
        htmlString = [@"<div style='text-align:justify; font-size:12px;font-family:Helvetica;color:#362932;'>" stringByAppendingString:htmlString];
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        self.txtCommon.attributedText = attributedString;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 
#pragma - Mark Consume Webservices methods

-(void) fetchPageDetail:(NSString *)pageID {
 
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
 NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,OTHER_PAGE_DETAIL,pageID] );
 
 [manager GET:[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,OTHER_PAGE_DETAIL,pageID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
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
 
         NSString *htmlString = [[[[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"HTMLDetail"];
         
         htmlString = [@"<div style='text-align:justify; font-size:12px;font-family:Helvetica;color:#362932;'>" stringByAppendingString:htmlString];
         NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                 initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                 options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                 documentAttributes: nil
                                                 error: nil
                                                 ];
         
         self.txtCommon.attributedText = attributedString;
         self.lblHeaderTitle.text =[[[[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"PageTitle"];
       
     }
     else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
     
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
     }
 }



- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
