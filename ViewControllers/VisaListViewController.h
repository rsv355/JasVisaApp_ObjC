//
//  VisaListViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 22/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisaListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic)NSString *strCountryID;
@property (strong,nonatomic)NSString *strNationalityID;
@property (strong,nonatomic)NSString *strTravelDate;
@property (strong,nonatomic)NSString *strVisaTypeID;

@property (strong,nonatomic)NSString *isDelegate;



@end
