//
//  HowToApplyViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToApplyViewController : UIViewController
{
    NSMutableArray  *arrayForBool,*arrayForImage;
    NSArray *sectionTitleArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;
@property (strong, nonatomic)  NSDictionary *dataDict;
@end
