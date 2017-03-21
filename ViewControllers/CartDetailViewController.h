//
//  CartDetailViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartDetailViewController : UIViewController


@property (strong, nonatomic) NSArray *packageArr;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;

@property (weak, nonatomic) IBOutlet UIImageView *imagePackage;
@property (weak, nonatomic) IBOutlet UILabel *lblNationality;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOFVisa;
@property (weak, nonatomic) IBOutlet UILabel *lblVisaRate;
@property (weak, nonatomic) IBOutlet UILabel *lblIsExpressVisa;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessingTime;

@end
