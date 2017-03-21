//
//  ViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+tintImage.h"

#import "HomeTableViewCell.h"

@interface ViewController ()
{
    HomeTableViewCell *cell;
    //F6C033 - YELLOW
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.btnMenu setImageTintColor:[UIColor  whiteColor] forState:UIControlStateNormal];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return  cell;
}

@end
