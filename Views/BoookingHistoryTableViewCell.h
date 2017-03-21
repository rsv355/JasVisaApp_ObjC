//
//  BoookingHistoryTableViewCell.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoookingHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBookingDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRefernceNo;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblNetAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionNo;
@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceNo;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPDF;
@end
