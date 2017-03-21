//
//  BookingHistoryViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "BookingHistoryViewController.h"
#import "BoookingHistoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "LoginViewController.h"

@interface BookingHistoryViewController () <LoginViewControllerDelegate>
{
    BoookingHistoryTableViewCell *cell;
    NSArray *dataArr;
}
@end

@implementation BookingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
        viewController.delegate = (id)self;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    else {
        NSLog(@"CALL SERVICE WITH :: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
         [self fetchBookingDetails];
    }

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
 #pragma mark- UITableView Datasource and Delegate methods
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 return [dataArr count];
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {

     cell=(BoookingHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
     
     cell.lblBookingDate.text  =[[dataArr objectAtIndex:indexPath.row] objectForKey:@"CreatedDate"];
     cell.lblRefernceNo.text  =[NSString stringWithFormat:@"Reference No. : %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"JASTRansactionID"]];
     cell.lblTotalAmount.text  =[NSString stringWithFormat:@"Total Amount : %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TotalAmount"]];
     cell.lblNetAmount.text  =[NSString stringWithFormat:@"Net Amount : %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"NetAmount"]];
     
     if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"InvoiceNo"] length] != 0) {
         
         cell.lblInvoiceNo.text  =[NSString stringWithFormat:@"Invoice No. : %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"InvoiceNo"]];
     }
     else {
         cell.lblInvoiceNo.text = @"";
     }
     
     if ([[[dataArr objectAtIndex:indexPath.row]objectForKey:@"IsPayuSuccess"] integerValue]) {
         if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Mihpayid"] length] != 0) {
             cell.lblTransactionNo.text  =[NSString stringWithFormat:@"Transaction No. : %@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Mihpayid"]];
         }
         else {
             cell.lblTransactionNo.text =@"";
         }
         
          cell.lblPaymentStatus.text  =@"Payment Successfull";
         [cell.lblPaymentStatus setTextColor:[UIColor colorWithRed:(0/255.0) green:(128/255.0) blue:(0/255.0) alpha:1.0]];
     }
     else {
       
         cell.lblTransactionNo.text  =@"";
         cell.lblPaymentStatus.text  =@"Payment Failed";
         [cell.lblPaymentStatus setTextColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0]];
     }
     
    /* if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"PDFName"] length] != 0) {
         
         NSString *pdfURL = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"PDFPath"] stringByAppendingString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"PDFName"]];
     }*/
     return  cell;
 }

/*
 {
 "CreatedDate": "Aug 19 2016  3:20PM",
 "DiscountAmount": 0,
 "InvoiceNo": "JAS/2016-17/39",
 "IsPayuSuccess": true,
 "JASTRansactionID": "JAS019358420760",
 "Mihpayid": "",
 "NetAmount": 400,
 "PDFName": "1be70a47-d1ab-4526-9a24-238446ff97a8.pdf",
 "PDFPath": "D:/Invoice/",
 "TotalAmount": 400
 },
 */

#pragma - Mark Consume Webservices methods

-(void) fetchBookingDetails {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,BOOKING_DETAILS,@"4"] );
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,BOOKING_DETAILS,@"4"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self parseDataResponseObject:responseArr];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
}
-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        dataArr = [[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"];
        [self.tableView reloadData];
    }
    else   {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
}


-(void)getFromLoginController:(NSString *)userID {
    
    [self viewDidLoad];
}

@end
