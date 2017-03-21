//
//  SettingViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 25/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "DataBaseFile.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "LoginViewController.h"

@interface SettingViewController () <LoginViewControllerDelegate>
{
    SettingTableViewCell *cell;
    NSArray *titleArr;
    NSArray *userArr;
    NSMutableArray *selectedArr, *changedValueArr;
    MBProgressHUD *hud;
    NSString *userID;
}

@property (strong, nonatomic) DataBaseFile *dbHandler;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbHandler = [[DataBaseFile alloc]init];
    [self.dbHandler CopyDatabaseInDevice];
    
    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    titleArr = [[NSArray alloc] initWithObjects:@"SMS Alert", @"Low fare Alert", @"I would like to be kept informed of special promotions and offers by Jas tourism", nil];
    
    selectedArr = [[NSMutableArray alloc]init];
    changedValueArr = [[NSMutableArray alloc]init];
    
    self.btnUpdateSetting.layer.cornerRadius = 4.0f;
    self.tableViewHeightConstant.constant = 67*3 ;
   
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
        viewController.delegate = (id)self;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    else {
        NSLog(@"CALL SERVICE WITH :: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
         [self fetchUserDataFromDatabase];
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=(SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lblSettingName.text = [titleArr objectAtIndex:indexPath.row];
    if ([changedValueArr count] !=0) {
        
            if ([[changedValueArr objectAtIndex:indexPath.row] integerValue] == 0) {
                cell.switchSetting.on = NO;
            }
            else {
                cell.switchSetting.on = YES;
            }

    }
    cell.switchSetting.tag = indexPath.row;
    [cell.switchSetting addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    return  cell;
}

-(void)switchValueChanged:(UISwitch *)sender {
    
    if (sender.on == YES) {
        
        [changedValueArr replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    else {
        
       [changedValueArr replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    NSLog(@">> %@",changedValueArr);
   
}
/*
 {
	"LowFareAlert":true,
	"SmsAlert":true,
	"SpecialAlert":true,
	"UserID":9223372036854775807
 }

 */
#pragma - mark Parse JSON Response methods
-(void) parseDataResponse:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        NSLog(@"RESPONSE >> %@",dictionary);
        
        NSString *updateQuery = [NSString stringWithFormat:@"update user set smsalert='%@', lowfarealert='%@', specialofferalert='%@'  where userID='%@'",[changedValueArr objectAtIndex:0],[changedValueArr objectAtIndex:1],[changedValueArr objectAtIndex:2], userID];
         NSLog(@"--->> %@",updateQuery);
        [self.dbHandler UpdateDataWithQuesy:updateQuery];

        
    }
    else   {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
        changedValueArr = selectedArr;
        [self showHud];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView reloadData];
            [self hideHud];
        });
        
    }
    
}

-(void)fetchUserDataFromDatabase {
    
   
    NSString *selectQuery = [NSString stringWithFormat:@"select * from user where userID = '%@'",userID];
    
    userArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:16];
    
    NSLog(@"ARRAY-- %@",userArr);
    
    [selectedArr addObject:[[userArr objectAtIndex:0] objectAtIndex:11]];
    [selectedArr addObject:[[userArr objectAtIndex:0] objectAtIndex:12]];
    [selectedArr addObject:[[userArr objectAtIndex:0] objectAtIndex:13]];
    changedValueArr = selectedArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    [self hideHud];
   
}

#pragma mark -MBProgressHUD methods
-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       [self.view addSubview:hud];
                       [hud show:YES];
                       
                   });
}

-(void)hideHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [hud hide:YES];
                       //[hud removeFromSuperview];
                       
                       
                   });
}

- (IBAction)btnUpdateSetting:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [changedValueArr objectAtIndex:0],@"SmsAlert",
                            [changedValueArr objectAtIndex:1],@"LowFareAlert",
                            [changedValueArr objectAtIndex:2],@"SpecialAlert",
                            userID,@"UserID",
                            nil];
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,UPDATE_USER_SETTING] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *dic1 = responseObject;
        [self parseDataResponse:dic1];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Please check Internet connectivity."];
    }];

}

-(void)getFromLoginController:(NSString *)userID {
    
    [self viewDidLoad];
}

@end
