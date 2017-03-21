//
//  PackageDescriptionViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "ViewController.h"

@interface PackageDescriptionViewController : ViewController

@property (nonatomic, strong)NSString *strToDisplay;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@end
