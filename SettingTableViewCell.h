//
//  SettingTableViewCell.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSettingName;
@property (weak, nonatomic) IBOutlet UISwitch *switchSetting;

@end
