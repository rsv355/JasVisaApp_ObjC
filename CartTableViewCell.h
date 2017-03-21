//
//  CartTableViewCell.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnMoreInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton *btnCancellationPolicy;
@property (weak, nonatomic) IBOutlet UIImageView *imagePackage;

@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;
@property (weak, nonatomic) IBOutlet UILabel *lblVisaFor;
@property (weak, nonatomic) IBOutlet UILabel *lblVisaType;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTravelDate;

@property (weak, nonatomic) IBOutlet UILabel *lblReviewPackageName;
@property (weak, nonatomic) IBOutlet UILabel *lblReviewDetail;
@end
