//
//  MenuTableViewController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuRow.h"

@implementation MenuTableViewController{
    NSUserDefaults *defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    //[defaults setObject:@"1" forKey:@"languageStatus"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    menuItems = [[NSMutableArray alloc] init];
    menuIcons = [[NSMutableArray alloc] init];
    menuItemIdentifire = [[NSMutableArray alloc] init];
    
    NSArray *defaultItems;
   
        defaultItems = [[NSArray alloc] initWithObjects:@"Home", @"My Profile", @"My Cart", @"My Bookings", @"Instant Pay", @"About Us", @"Contact Us", @"Submit Feedback", @"Settings", @"Sign Out", nil];
  

    NSArray *defaultIcons = [[NSArray alloc] initWithObjects:@"ic_home.png", @"ic_profile.png", @"ic_cart.png",  @"ic_booking.png", @"ic_instant_pay.png", @"ic_about_us.png",@"ic_contactus.png", @"ic_feedback.png", @"settings-work-tool.png", @"ic_signout.png", nil];
   
    NSArray *defaultsMenuitemIdentifire = [[NSArray alloc] initWithObjects:@"HOME",@"PROFILE",@"CART",@"BOOKING_HISTORY",@"INSTANT_PAY",@"ABOUT",@"CONTACT_US", @"SUBMIT_FEEDBACK",@"SETTINGS",@"LOGIN", nil];
    
    [menuItems addObjectsFromArray:defaultItems];
    [menuIcons addObjectsFromArray:defaultIcons];
    [menuItemIdentifire addObjectsFromArray:defaultsMenuitemIdentifire];
   
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MenuRow *cell = [tableView dequeueReusableCellWithIdentifier:@"menuRow" forIndexPath:indexPath];
    [cell.menuLabel setText:[menuItems objectAtIndex:indexPath.row]];
    [cell.menuIcon setImage:[UIImage imageNamed:[menuIcons objectAtIndex:indexPath.row]]];
    
    [cell.menuIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.menuIcon setTintColor:[UIColor colorWithRed:(117/255.0) green:(117/255.0) blue:(117/255.0) alpha:1.0f]];
    return cell;
}

-(void)tableView: (UITableView*)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath {
    
        [self.menuDrawerViewController setContent:[menuItemIdentifire objectAtIndex:indexPath.row]];
    
    
}

@end
