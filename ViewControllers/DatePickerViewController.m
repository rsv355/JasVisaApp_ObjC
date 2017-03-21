//
//  DatePickerViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 01/09/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "DatePickerViewController.h"
#import "CustomAnimationAndTransiotion.h"

@interface DatePickerViewController ()
{
    NSString *strSelectedDate;
    NSDateFormatter *dateFormatter;
}
@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGAffineTransform scale = CGAffineTransformMakeScale(0.80, 1);
    self.datePicker.transform = CGAffineTransformConcat(self.datePicker.transform, scale);
    self.viewPicker.layer.borderWidth = 2.0f;
    self.viewPicker.layer.borderColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;
    self.viewPicker.layer.cornerRadius = 4.0f;
    [self setViewCard];


    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    strSelectedDate = [dateFormatter stringFromDate:self.datePicker.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setViewCard {
    
    self.viewPicker.layer.masksToBounds = NO;
    self.viewPicker.layer.cornerRadius = 2.0; // if you like rounded corners
    self.viewPicker.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.viewPicker.layer.shadowRadius = 1;
    
    self.viewPicker.layer.shadowOpacity = 0.5;
    self.viewPicker.layer.shadowColor = [UIColor  grayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.viewPicker.bounds];
    self.view.layer.shadowPath = path.CGPath;
}

- (IBAction)datePickerClicked:(id)sender {
  
   strSelectedDate = [dateFormatter stringFromDate:self.datePicker.date];
    NSLog(@"Selected Date :: %@",strSelectedDate);
}

- (IBAction)btnDone:(id)sender {
   
    NSLog(@"Selected Date :: %@",strSelectedDate);
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(selectedDate:)])
    {
        [_delegate selectedDate:strSelectedDate];
    }

}
- (IBAction)btnCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
