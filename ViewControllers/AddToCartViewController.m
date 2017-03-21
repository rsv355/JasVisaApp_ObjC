//
//  AddToCartViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "AddToCartViewController.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"
#import "DatePickerViewController.h"
#import "UIView+Toast.h"
#import "JASAPPURL.h"

@interface AddToCartViewController ()<DatePickerDelegate>
{
    NSString *strNationalityID, *strTravelDate, *strTotalVisa, *strTotal;
    
    NSInteger strSelectedButton;
    NSMutableArray *countryArr;
    NSMutableArray *visaTypeArr,*visaTypeIDArr;
    NSMutableArray *nationalityArr,*nationalityName;
    NSInteger strChecked1, strChecked2;
}
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;
@end

@implementation AddToCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCardViewForButton:self.btnTotalVisa];
    [self setCardViewForButton:self.btnTravelDate];
    [self setCardViewForButton:self.btnNationality];
    
    NSLog(@"PACKAGE INFO :: > %@", _packageDict);
    
    self.btnAddToCart.layer.cornerRadius = 4.0f;
    
    _btnCheckbox1.layer.borderWidth = 2.0f;
    _btnCheckbox1.layer.borderColor = [UIColor grayColor].CGColor;
    
    _btnCheckbox2.layer.borderWidth = 2.0f;
    _btnCheckbox2.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    strSelectedButton = 0;
    strNationalityID = @"0";
    strTravelDate = @"0";
    strTotalVisa = @"0";
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self fetchNationalityDataFromDatabase];
    
    [self countTotalSurchargeForTotalVisa:[strTotalVisa integerValue] ExpressRate:strChecked1 OTBRate:strChecked2];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark UIButton IBAction 

- (IBAction)btnAddToCart:(id)sender {
    
    if ([strNationalityID integerValue] == 0) {
        [self.view makeToast:@"Please select Nationality"];
    }
    else if ([strTravelDate integerValue] == 0) {
        [self.view makeToast:@"Please select travel date."];
    }
    else if ([strTotalVisa integerValue] == 0) {
        [self.view makeToast:@"Please select No. of visa"];
    }
    else if([self cartItemCount] >=2) {
        [self.view makeToast:@"You can not add more than 2 items in Cart."];
    }
    else if([self cartItemExist] !=0){
        [self.view makeToast:@"Item already exists in cart."];
    }
    else {
        NSString *strUserID;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
            strUserID = @"0";
        }
        else {
            strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        }
        NSString *strPackageID = [self.packageDict valueForKey:@"VisaPackageID"];
        NSString *strPackageName = [self.packageDict valueForKey:@"PackageName"];
        NSString *strRegularRate = [self.packageDict valueForKey:@"RegularRate"];
        NSString *strExpressRate = [self.packageDict valueForKey:@"ExpressRate"];
        NSString *strOTBRate = [self.packageDict valueForKey:@"OTBRate"];
        NSString *strRates = [self.packageDict valueForKey:@"Rates"];
        NSString *strProcessingTime = [self.packageDict valueForKey:@"ProcessingTime"];
        NSString *strPackageImage =@" ";
        if ([[self.packageDict valueForKey:@"PackageImage"] length] !=0) {
            strPackageImage = [[self.packageDict valueForKey:@"PackageImagePath"] stringByAppendingString:[self.packageDict valueForKey:@"PackageImage"]];
        }
        
        NSString *strTagLine1 = [self.packageDict valueForKey:@"TagLine1"];
        NSString *strTagLine2 = [self.packageDict valueForKey:@"TagLine2"];
        NSString *strCancellationPolicy = [self.packageDict valueForKey:@"CancellationPolicy"];
        NSString *strCountryID = [self.packageDict valueForKey:@"CountryID"];
    
        NSString *strIsExpressRate;
        if (strChecked1 == 0) {
            strIsExpressRate = @"0";
        }
        else {
            strIsExpressRate = @"1";
        }
       
        NSString *strIsOTBRate ;
        if (strChecked2 == 0) {
            strIsOTBRate = @"0";
        }
        else {
            strIsOTBRate = @"1";
        }
        NSString *strSurcharge = [NSString stringWithFormat:@"%.2f",DEFAULT_SURCHARGE];
        NSString *strVisaForName = [self.packageDict valueForKey:@"VisaForName"];
        NSString *strVisaTypeName = [self.packageDict valueForKey:@"VisaTypeName"];
       
        NSString *insertQuery = [NSString stringWithFormat:@"insert into cart (user_id, package_id, package_name, regular_rate, express_rate, OTB_rate, rates, package_image, tagline_1, tagline_2, cancellation_policy, country_id, nationality_id, travel_date, no_of_visa, total, isExpressRate, isOTBRate, surcharge, visaFor_name, visaType_name, processing_time) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",strUserID, strPackageID, strPackageName, strRegularRate, strExpressRate, strOTBRate, strRates, strPackageImage, strTagLine1, strTagLine2, strCancellationPolicy, strCountryID, strNationalityID, strTravelDate, strTotalVisa, strTotal, strIsExpressRate, strIsOTBRate, strSurcharge, strVisaForName, strVisaTypeName, strProcessingTime];
        NSLog(@"--->>%@",insertQuery);
        [self.dbHandler insertDataWithQuesy:insertQuery];

        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view makeToast:@"Package successfully added to Cart."];
    }
    
}

-(NSInteger) cartItemCount {
    
    NSString *cartCountQuery = [NSString stringWithFormat:@"select count(*) from cart"];
    NSInteger countItem = [[self.dbHandler MathOperationInTable:cartCountQuery] integerValue];

    return countItem;
}

-(NSInteger) cartItemExist {
    //package_id
    NSString *cartCountQuery = [NSString stringWithFormat:@"select count(*) from cart where package_id='%@'",[self.packageDict valueForKey:@"VisaPackageID"]];
    NSInteger countItem = [[self.dbHandler MathOperationInTable:cartCountQuery] integerValue];
    
    return countItem;
}
- (IBAction)btnSelectCriteria:(id)sender {
    
    if ([sender tag] == 1)  {
        
        strSelectedButton = 1;
        
        if(dropDown == nil) {
            CGFloat f = 200;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :nationalityName :nil :@"down"];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:sender];
            [self rel];
        }
        
    }
    if ([sender tag] == 3)  {
        
        strSelectedButton = 3;
        
        NSArray * arr = [[NSArray alloc] init];
        arr = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5",nil];
        
        if(dropDown == nil) {
            CGFloat f = 200;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:sender];
            [self rel];
        }
        
    }

}

- (IBAction)btnCheckBox:(id)sender {
    
    if ([sender tag] == 1) {
       
        if (strChecked1 == 0) {
           
            strChecked1 = [[self.packageDict valueForKey:@"ExpressRate"] integerValue];
            [self.btnCheckbox1 setImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        }
        else {
            strChecked1 = 0;
            [self.btnCheckbox1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        [self countTotalSurchargeForTotalVisa:[strTotalVisa integerValue] ExpressRate:strChecked1 OTBRate:strChecked2];
    }
    else if ([sender tag] == 2) {
        
        if (strChecked2 == 0) {
            strChecked2 = [[self.packageDict valueForKey:@"OTBRate"] integerValue];
            [self.btnCheckbox2 setImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        }
        else  {
            strChecked2 = 0;
            [self.btnCheckbox2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        [self countTotalSurchargeForTotalVisa:[strTotalVisa integerValue] ExpressRate:strChecked1 OTBRate:strChecked2];
    }
    
}

-(void)fetchNationalityDataFromDatabase {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from nationality_master"];
    nationalityArr = [[NSMutableArray alloc]init];
    nationalityName = [[NSMutableArray alloc]init];
    
    nationalityArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:3];
    for (int i = 0; i<[nationalityArr count]; i++) {
        [nationalityName addObject:[[nationalityArr objectAtIndex:i] objectAtIndex:1]];
    }
 }

- (IBAction)btnTravelDate:(id)sender {
    
    DatePickerViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DATE_PICKER"];
    popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];

}


#pragma mark -  NIDropDown Delegate methods

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void) selectedIndex:(NSInteger)selectedIndex {
    
    if (strSelectedButton == 1) {
         strNationalityID = [[nationalityArr objectAtIndex:selectedIndex] objectAtIndex:0];
    }
    else {
        NSLog(@"----->> %@",self.btnTotalVisa.currentTitle);
        strTotalVisa = self.btnTotalVisa.currentTitle;
        
        [self countTotalSurchargeForTotalVisa:[strTotalVisa integerValue] ExpressRate:strChecked1 OTBRate:strChecked2];
    }
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}


-(void)setCardViewForButton :(UIButton *)button {
    
    button.layer.masksToBounds = NO;
    button.layer.cornerRadius = 3; // if you like rounded corners
    button.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    button.layer.shadowRadius = 1;
    
    button.layer.shadowOpacity = 0.7;
    
    button.layer.shadowColor = [UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:button.bounds];
    button.imageView.layer.shadowPath = path.CGPath;
    
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIViewController Custom Delegate

-(void)selectedDate:(NSString *)strdate {
    
    NSLog(@"Your Selected date is :: %@",strdate);
    strTravelDate = strdate;
    [self.btnTravelDate setTitle:strdate forState:UIControlStateNormal];
}


-(void) countTotalSurchargeForTotalVisa:(NSInteger)visaNo ExpressRate:(NSInteger)express OTBRate:(NSInteger)otb {
   
    
    if (visaNo == 0) {
        visaNo = 1;
    }
    float regularRate = [[self.packageDict valueForKey:@"RegularRate"] floatValue];
 //   float regularRate = 5600;
    float expressRate = express * visaNo;
    float otbRate = otb *visaNo;
    
    float total = regularRate * visaNo;
    
    total = total + expressRate + otbRate;
    
    float surcharge = (total*DEFAULT_SURCHARGE)/(100 +DEFAULT_SURCHARGE);
    
    strTotal = [NSString stringWithFormat:@"%.2f",total];
    [self.lblTotal setText:[NSString stringWithFormat:@"₹ %.2f",total]];

    [self.lblSurcharge setText:[NSString stringWithFormat:@"₹ %.2f (%.2f Surcharges)",surcharge,DEFAULT_SURCHARGE]];
   
}
@end
