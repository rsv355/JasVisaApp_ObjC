//
//  CommonViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *txtCommon;

@property (strong, nonatomic) NSString *storyboardID;
@property (strong, nonatomic) NSString *strCommon;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeaderHeightConstant;

@end
