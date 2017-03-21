//
//  CartPackageListViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 07/09/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "CartPackageListViewController.h"
#import "CartTableViewCell.h"
#import "DataBaseFile.h"
#import "TravellerDetailViewController.h"

@interface CartPackageListViewController () <TravellerViewControllerDelegate>
{
    CartTableViewCell *cell;
    NSArray *dataArr;
    NSMutableArray *countArr;
}
@property(strong,nonatomic)DataBaseFile *dbHandler;
@end

@implementation CartPackageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self fetchPackageDetailsFromDatabase];
    
    
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
     cell.lblReviewPackageName.text = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:1];
     cell.lblReviewDetail.text = [NSString stringWithFormat:@"%@/%@ completed",[countArr objectAtIndex:indexPath.row],[[dataArr objectAtIndex:indexPath.row]objectAtIndex:2]];
     return  cell;
 }



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TravellerDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TRAVELLER_DETAIL"];
    viewController.packageId = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:0];
    viewController.totalVisaNo = [[dataArr objectAtIndex:indexPath.row] objectAtIndex:2];
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnBack:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void) fetchPackageDetailsFromDatabase {
    
    countArr = [[NSMutableArray alloc]init];
    
    NSString *selectQuery = [NSString stringWithFormat:@"select package_id,package_name,no_of_visa from cart"];
    
    dataArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:3];
    
    for (int i=0; i<[dataArr count]; i++) {
        NSString *countQuery = [NSString stringWithFormat:@"select count(i.image_id) from cart As c JOIN travel_detail As t  ON c.package_id = t.package_id JOIN traveler_images As i ON t.traveler_id = i.traveler_id where c.package_id = '%@' AND i.isPassportFTP = '1' AND i.isPhotoFTP = '1'",[[dataArr objectAtIndex:i] objectAtIndex:0]];
         NSArray* countArr1 = [self.dbHandler selectAllDataFromTablewithQuery:countQuery ofColumn:1];
        [countArr addObject:[[countArr1 objectAtIndex:0] objectAtIndex:0]];
    }
    NSLog(@"CUONT----->>%@",countArr);
   
    
    [self.tableView reloadData];
    
}

-(NSInteger) countTotalTravelerAllowed:(NSString *)packageID {
    
    NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from traveler_detail where package_id='%@'",packageID];
    return [[self.dbHandler MathOperationInTable:selectSwitch] integerValue];
}

-(void) getBackFromController {
    [self viewDidLoad];
}
@end
