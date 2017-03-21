//
//  SearchViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 23/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "JASAPPURL.h"
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"
#import "DatePickerViewController.h"

@interface SearchViewController ()<DatePickerDelegate>
{
    SearchTableViewCell *cell;
    MBProgressHUD *hud;
    NSArray *dataArr;
    NSString *strCountryID, *strNationalityID, *strTravelDate, *strVisaTypeID;
    
    NSInteger strSelectedButton;
    NSMutableArray *countryArr;
    NSMutableArray *visaTypeArr,*visaTypeIDArr;
    NSMutableArray *nationalityArr,*nationalityName;

}
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];

    [self setCardViewForButton:self.btnVisaFor];
    [self setCardViewForButton:self.btnVisaType];
    [self setCardViewForButton:self.btnNationality];
    [self setCardViewForButton:self.btnExpectedTravelDate];
    
    self.btnSearch.layer.cornerRadius = 4.0f;
    strCountryID = @"0";
    strVisaTypeID =@"0";
    strNationalityID = @"0";
    
    [self showHud];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchVisaType];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchNationalityDataFromDatabase];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (IBAction)btnSelectSearchCriteria:(id)sender {
    
    if ([sender tag] == 1)  {
        
        strSelectedButton = 1;
        dropDown.tag = 1;
        if(dropDown == nil) {
            CGFloat f = 200;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :countryArr :nil :@"down"];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:sender];
            [self rel];
        }

    }
    
    else if ([sender tag] == 2)  {
        
        strSelectedButton = 2;
        
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
    else if ([sender tag] == 3)  {
        
        strSelectedButton = 3;
        if ([strCountryID integerValue] == 0) {
            
            [self.view makeToast:@"Please Select Country."];
        }
        else {
         
            if(dropDown == nil) {
                CGFloat f = 200;
                dropDown = [[NIDropDown alloc]showDropDown:sender :&f :visaTypeArr :nil :@"down"];
                dropDown.delegate = self;
            }
            else {
                [dropDown hideDropDown:sender];
                [self rel];
            }
        }
       
        
    }

}

#pragma mark -  NIDropDown Delegate methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {

    [self rel];
}

-(void) selectedIndex:(NSInteger)selectedIndex {
  
    if (strSelectedButton == 1) {
        
        strVisaTypeID = @"0";
        [self.btnVisaType setTitle:@"Visa Type" forState:UIControlStateNormal];
        
        strCountryID = [[dataArr objectAtIndex:selectedIndex] objectForKey:@"CountryID"];
        
        NSArray *ary = [[dataArr objectAtIndex:selectedIndex] objectForKey:@"VisaTypes"];
        
        visaTypeArr = [[NSMutableArray alloc]init];
        visaTypeIDArr = [[NSMutableArray alloc]init];

        [visaTypeArr addObject:@"Select"];
        
        for (int i = 0; i<[ary count]; i++) {
            [visaTypeArr addObject:[[ary objectAtIndex:i] objectForKey:@"VisaType"]];
             [visaTypeIDArr addObject:[[ary objectAtIndex:i] objectForKey:@"VisaTypeID"]];
        }
    
    }
    else if (strSelectedButton == 2) {
        strNationalityID = [[nationalityArr objectAtIndex:selectedIndex] objectAtIndex:0];
    }
    else if (strSelectedButton == 3) {
       
        if (selectedIndex == 0) {
            strVisaTypeID = @"0";
        }
        else {
            strVisaTypeID = [visaTypeIDArr objectAtIndex:selectedIndex-1];
        }
        
    }
}

-(void)rel{
  
    dropDown = nil;
}

#pragma mark -  UIButton IBAction

- (IBAction)btnSearch:(id)sender {
    
    
    if ([strCountryID integerValue] == 0) {
        
        [self.view makeToast:@"Select Country."];
    }
    else if ([strNationalityID integerValue] == 0) {
        
        [self.view makeToast:@"Select Nationality."];
    }
    else if ([strTravelDate integerValue] == 0) {
        
        [self.view makeToast:@"Select Expected Travel Date."];
    }
    else if ([strVisaTypeID integerValue] == 0) {
        
        [self.view makeToast:@"Select Visa Type."];
    }
    else {
        
        NSLog(@"%@---%@---%@---%@",strCountryID,strNationalityID,strTravelDate,strVisaTypeID);
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getFromSearchControllerFor:nationality:travelDate:visaType:)])
        {
            [_delegate getFromSearchControllerFor:strCountryID nationality:strNationalityID travelDate:strTravelDate visaType:strVisaTypeID];
        }

    }
}

- (IBAction)btnTravelDate:(id)sender {
    
    DatePickerViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DATE_PICKER"];
    popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}

#pragma - Mark Consume Webservices methods

-(void) fetchVisaType {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,VISA_FOR_COUNTRY_NAME,@"1"] );
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@%@",JAS_BASEURL,JAS_ACCOUNTURL,VISA_FOR_COUNTRY_NAME,@"1"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self parseDataResponseObject:responseArr];
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
}
-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        dataArr = [[dictionary objectForKey:@"ResponseData"] objectForKey:@"Data"];
       
        countryArr = [[NSMutableArray alloc] init];
        for (int i=0; i<[dataArr count]; i++) {
            
            [countryArr addObject:[[dataArr objectAtIndex:i] objectForKey:@"CountryName"]];
        }
       
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMsg"]];
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

#pragma mark - UIViewController Custom Delegate 

-(void)selectedDate:(NSString *)strdate {
    
    NSLog(@"Your Selected date is :: %@",strdate);
    strTravelDate = strdate;
    [self.btnExpectedTravelDate setTitle:strdate forState:UIControlStateNormal];
}

@end
