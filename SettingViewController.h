//
//  SettingViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstant;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateSetting;
- (IBAction)btnUpdateSetting:(id)sender;
@end
