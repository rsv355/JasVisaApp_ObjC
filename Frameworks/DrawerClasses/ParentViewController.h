//
//  ParentViewController.h
//  ShreeSwastik
//
//  Created by Developers on 01/12/15.
//  Copyright (c) 2015 ShreeSwastik. All rights reserved.
//

#import "ViewController.h"
#import "MainContentNavigationController.h"


@interface ParentViewController : ViewController
@property (nonatomic,strong) MainContentNavigationController *mainContentNavigationController;
@property (weak, nonatomic) IBOutlet UIView *parentContentContainer;

-(void)setSubContent:(NSString*)storyboardID;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@end
