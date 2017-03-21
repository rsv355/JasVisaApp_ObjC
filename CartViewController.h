//
//  CartViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "ViewController.h"

@interface CartViewController : ViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnProceedToCheckout;
- (IBAction)btnProceedToCheckout:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBotton;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *lblGrandTotal;
@end
