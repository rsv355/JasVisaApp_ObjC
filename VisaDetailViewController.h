//
//  VisaDetailViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 23/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisaDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentControlHeightConstant;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) NSString *strVisaPackageID;



@end
