//
//  SearchViewController.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 23/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@protocol SearchViewControllerDelegate <NSObject>

@required
- (void)getFromSearchControllerFor:(NSString *)visaForID nationality:(NSString *)nationalityID travelDate:(NSString *)date visaType:(NSString *)visaTypeID;

@end

@interface SearchViewController : UIViewController <NIDropDownDelegate>
{
     NIDropDown *dropDown;
}

@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;


- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnVisaFor;
@property (weak, nonatomic) IBOutlet UIButton *btnNationality;
@property (weak, nonatomic) IBOutlet UIButton *btnExpectedTravelDate;

@property (weak, nonatomic) IBOutlet UIButton *btnVisaType;

- (IBAction)btnSelectSearchCriteria:(id)sender;

-(void)rel;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnSearch:(id)sender;
- (IBAction)btnTravelDate:(id)sender;
@end
