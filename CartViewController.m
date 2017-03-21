//
//  CartViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "CustomAnimationAndTransiotion.h"
#import "UIButton+tintImage.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "DataBaseFile.h"
#import "UIImageView+AFNetworking.h"
#import "CommonViewController.h"
#import "CartDetailViewController.h"

@interface CartViewController () <LoginViewControllerDelegate>
{
    CartTableViewCell *cell;
    NSArray *dataArr;
    NSString  *cartID;
    float grandTotal;
}
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnProceedToCheckout.layer.cornerRadius = 4.0f;
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self fetchCartDataFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(CartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell.btnMoreInfo setImageTintColor:[UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:0.8] forState:UIControlStateNormal];
   
    [cell.btnDelete setImageTintColor:[UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:0.8] forState:UIControlStateNormal];
    
    cell.imagePackage.layer.cornerRadius = 3.0f;
    cell.imagePackage.layer.masksToBounds = YES;
    
    cell.btnMoreInfo.tag = indexPath.row;
    [cell.btnMoreInfo addTarget:self action:@selector(btnMoreInfo:) forControlEvents:UIControlEventTouchDown];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchDown];
    
    cell.btnCancellationPolicy.tag = indexPath.row;
    [cell.btnCancellationPolicy addTarget:self action:@selector(btnCancellationPolicy:) forControlEvents:UIControlEventTouchDown];

    
    cell.lblPackageName.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:3];
    cell.lblVisaFor.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:20];
    cell.lblVisaType.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:21];
    cell.lblTravelDate.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:14];
    cell.lblTotal.text = [NSString stringWithFormat:@"₹ %@",[[dataArr objectAtIndex:indexPath.row] objectAtIndex:16]];
    [cell.imagePackage setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:indexPath.row] objectAtIndex:8]]];

    return  cell;
}

-(IBAction)btnMoreInfo:(UIButton *)sender {

    CartDetailViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"CART1"];
    popover.packageArr = [dataArr objectAtIndex:sender.tag];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}

-(IBAction)btnDelete:(UIButton *)sender {

    cartID = [[dataArr objectAtIndex:sender.tag] objectAtIndex:0];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to remove?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = 1;
    [alertView show];
}

-(IBAction)btnCancellationPolicy:(UIButton *)sender {
    
    CommonViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COMMON"];
    viewController.storyboardID = @"POLICY";
    viewController.strCommon = [[dataArr objectAtIndex:sender.tag] objectAtIndex:11];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void) fetchCartDataFromDatabase {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from cart"];
    
    dataArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:23];

    NSLog(@">>>%ld",(long)[dataArr count]);
    [self.tableView reloadData];
    
    grandTotal = 0.0;

    for (int i=0; i<[dataArr count]; i++) {
        grandTotal = grandTotal + [[[dataArr objectAtIndex:i] objectAtIndex:16] floatValue];
    }
    self.lblGrandTotal.text = [NSString stringWithFormat:@"₹ %.2f",grandTotal];
    if ([dataArr count] == 0) {
        [self.viewBotton setHidden:YES];
        [self.lblEmptyView setHidden:NO];
    }
    else {
        [self.viewBotton setHidden:NO];
        [self.lblEmptyView setHidden:YES];
    }
}
- (IBAction)btnProceedToCheckout:(id)sender {
   
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
        viewController.delegate = (id)self;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    else {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CART_PACKAGE_LIST"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - UIViewController Custom delegate methods
-(void)getFromLoginController:(NSString *)userID {

    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CART_PACKAGE_LIST"];
    [self presentViewController:viewController animated:YES completion:nil];

}


#pragma mark - UIAlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
            NSString *deleteQuery =[NSString stringWithFormat:@"delete from cart where cart_id='%@'",cartID];
            [self.dbHandler DeleteDataWithQuesy:deleteQuery];
            [self fetchCartDataFromDatabase];
    }
}
@end
