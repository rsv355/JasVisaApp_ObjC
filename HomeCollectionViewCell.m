//
//  HomeCollectionViewCell.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 22/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
-(void)awakeFromNib {
    [self setViewCard];
}

-(void)setViewCard {
    
    [self.contentView setAlpha:1];
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 1; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowRadius = 1;
    
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.visaImageView.layer.shadowPath = path.CGPath;
}

@end
