//
//  CartTableViewCell.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewCard];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setViewCard {
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 1; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowRadius = 1;
    
    self.layer.shadowOpacity = 0.2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.imageView.layer.shadowPath = path.CGPath;
}
@end
