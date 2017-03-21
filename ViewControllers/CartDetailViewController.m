//
//  CartDetailViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "CartDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CartDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;
@end

@implementation CartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewCard];
    self.cardView.layer.cornerRadius = 4.0f;
    NSLog(@"SELECTED CART ITEM-->> %@",self.packageArr);
    [self setDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetails {
    
    self.lblPackageName.text = [self.packageArr objectAtIndex:3];
    self.lblNationality.text = [NSString stringWithFormat:@"Visitor's Nationality : %@",[self.packageArr objectAtIndex:0]];
    self.lblNoOFVisa.text = [NSString stringWithFormat:@"No. of Visa : %@",[self.packageArr objectAtIndex:15]];
    self.lblVisaRate.text = [NSString stringWithFormat:@"Visa Rate : ₹ %@",[self.packageArr objectAtIndex:16]];
    if ([[self.packageArr objectAtIndex:17] integerValue] == 0) {
         self.lblIsExpressVisa.text = [NSString stringWithFormat:@"Express Visa : %@",@"False"];
    }
    else {
        self.lblIsExpressVisa.text = [NSString stringWithFormat:@"Express Visa : %@",@"True"];
    }
   
    self.lblProcessingTime.text = [NSString stringWithFormat:@"Processing time : %@",[self.packageArr objectAtIndex:22]];
     [self.imagePackage setImageWithURL:[NSURL URLWithString:[self.packageArr objectAtIndex:8]]];
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setViewCard {
   
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 1; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.cardView.layer.shadowRadius = 1;
    
    self.cardView.layer.shadowOpacity = 0.8;
    self.cardView.layer.shadowColor = [UIColor  darkGrayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
}
@end
