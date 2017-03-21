//
//  HomeCollectionViewCell.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 22/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *visaImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;
@property (weak, nonatomic) IBOutlet UILabel *lblLine1;
@property (weak, nonatomic) IBOutlet UILabel *lblLine2;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@end
