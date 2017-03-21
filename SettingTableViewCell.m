//
//  SettingTableViewCell.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

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
    
    [self.contentView setAlpha:1];
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 1; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowRadius = 1;
    
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    // self.layer.shadowColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.imageView.layer.shadowPath = path.CGPath;
}
@end
