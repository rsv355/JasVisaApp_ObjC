//
//  AddToCartViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "ViewController.h"
#import "NIDropDown.h"

@interface AddToCartViewController : ViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}


@property (weak, nonatomic) IBOutlet UIButton *btnNationality;
@property (weak, nonatomic) IBOutlet UIButton *btnTravelDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTotalVisa;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
- (IBAction)btnAddToCart:(id)sender;

- (IBAction)btnSelectCriteria:(id)sender;
- (IBAction)btnTravelDate:(id)sender;

- (IBAction)btnCheckBox:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox1;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox2;


-(void)rel;

@property (strong, nonatomic) NSDictionary *packageDict;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblSurcharge;

@end
