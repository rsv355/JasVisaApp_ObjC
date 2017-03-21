//
//  DatePickerViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 01/09/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DatePickerDelegate <NSObject>

@required
- (void)selectedDate:(NSString *)strdate;

@end

@interface DatePickerViewController : UIViewController

@property (nonatomic, weak) id<DatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;

@end
