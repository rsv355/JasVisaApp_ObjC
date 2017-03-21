//
//  VisaListViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 22/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "VisaListViewController.h"
#import "HomeCollectionViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"
#import "UIImageView+AFNetworking.h"
#import "VisaDetailViewController.h"
#import "AddToCartViewController.h"

@interface VisaListViewController ()
{
    HomeCollectionViewCell *cell;
    NSArray *visaListArr;
}
@end

@implementation VisaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_isDelegate integerValue] == 0) {
        
        [self fetchVisaDetailForCountryID:DEFAULT_COUNTRY_ID nationality:DEFAULT_NATIONALITY_ID date:DEFAULT_EXPECTED_DATE visaType:DEFAULT_VISA_TYPE_ID];
    }
    else {
         [self fetchVisaDetailForCountryID:_strCountryID nationality:_strNationalityID date:_strTravelDate visaType:_strVisaTypeID];
    }
    
    NSLog(@"DELEGATE--->>%@",_isDelegate);
     NSLog(@"LOGIN_USER_ID----->>%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [visaListArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.btnAddToCart.tag = indexPath.row;
    [cell.btnAddToCart addTarget:self action:@selector(btnAddToCart:) forControlEvents:UIControlEventTouchDown];
    
    [cell.lblPackageName setText:[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"PackageName"]];
    [cell.lblLine1 setText:[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"TagLine1"]];
    [cell.lblLine2 setText:[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"TagLine2"]];
    [cell.lblPrice setText:[NSString stringWithFormat:@"$ %@",[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"RegularRate"]]];
    if ([[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"PackageImage"] length]!= 0) {
        
        NSString *strImagePath  = [NSString stringWithFormat:@"%@%@",[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"PackageImagePath"],[[visaListArr objectAtIndex:indexPath.row] objectForKey:@"PackageImage"]];
        [cell.visaImageView setImageWithURL:[NSURL URLWithString:strImagePath]];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width/2 - 16;
    side2=collectionviewSize.height;
    return CGSizeMake(side1, side1+80);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    VisaDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VISA_DETAIL"];
    viewController.strVisaPackageID = [[visaListArr objectAtIndex:indexPath.row] objectForKey:@"VisaPackageID"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}



-(void)btnAddToCart:(UIButton *)sender {
    
    AddToCartViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_TO_CART"];
    viewController.packageDict = [visaListArr objectAtIndex:sender.tag];
    [self presentViewController:viewController animated:YES completion:nil];

}

-(void)fetchVisaDetailForCountryID:(NSString *)countryID nationality:(NSString *)nationalityID date:(NSString *)travelDate visaType:(NSString *)visaTypeID {
    
    NSLog(@"---->> %@",[NSString stringWithFormat:@"%@%@%@",JAS_BASEURL,JAS_VISAURL,VISA_LIST]);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            countryID,@"CountryID",
                            nationalityID,@"Nationality",
                            travelDate,@"TravelDate",
                            visaTypeID,@"VisaTypeID",
                            nil];
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:@"http://ws-srv-net.in.webmyne.com/Applications/dreamsdesign.us/JasWCF/Services/Visa.svc/json/GetVisaPackage" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

-(void) parseDataResponse:(NSDictionary *)dictionary {

    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        NSLog(@"DATA---->> %@",[[[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"] objectAtIndex:0]);
        visaListArr = [[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"];
        [self.collectionView reloadData];
        
        NSLog(@"TOTAL VISA LIST COUNT :: >> %ld",[visaListArr count]);
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
    }
        
}
@end
