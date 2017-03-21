//
//  PackageDescriptionViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "PackageDescriptionViewController.h"

@interface PackageDescriptionViewController ()

@end

@implementation PackageDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *htmlString;
    NSLog(@"--%@",_strToDisplay);
    htmlString = [@"<div style='text-align:justify; font-size:12px;font-family:Helvetica;color:#362932;'>" stringByAppendingString:_strToDisplay];
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.txtDescription.attributedText = attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
