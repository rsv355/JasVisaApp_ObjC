//
//  TravellerDetailViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 26/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "TravellerDetailViewController.h"
#import "TravellerTableViewCell.h"
#import "AddTravellerViewController.h"
#import "DataBaseFile.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "JASAPPURL.h"
#import "AddTravellerViewController.h"

@interface TravellerDetailViewController ()<AddTravellerViewControllerDelegate>
{
    TravellerTableViewCell *cell;
    MBProgressHUD *hud;
    
    NSMutableArray *otherTravellerArr;
    NSMutableArray *nationalityArr,*nationalityName;
    NSString *strNationalityID;
    NSInteger buttonTappped;
    UIImage *image1 ;
    NSMutableArray *imageStatusArr, *imagePathArr, *imageDataArr;
    NSString *letters, *randomString;
    NSString *traveler_id;
}
@property(strong,nonatomic)DataBaseFile *dbHandler;

@end

@implementation TravellerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"SEL PACKAGE ---->> %@ for--->> %@", _packageId, _totalVisaNo);
    
  
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    otherTravellerArr = [[NSMutableArray alloc]init];
     strNationalityID = @"0";
    
    [self.btnNationality addTarget:(id)self action:@selector(nationalityTouched:) forControlEvents:UIControlEventTouchDown];
    [self setLayout];
    [self setTextFieldLayout];
    [self fetchNationalityDataFromDatabase];
    [self fetchDataFromDatabase];
    [self fetchLeadTravlerDataFromDatabase];
    [self setDataLayout];
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    randomString = [self randomStringWithLength:10];

}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString1 = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString1 appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setDataLayout {
    if ([self.travelerDetailArr count] == 0) {
        imageStatusArr = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0", nil];
        imagePathArr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];
        imageDataArr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];
        
        traveler_id = @"0";
        [self.btnPassport setUserInteractionEnabled:NO];
        [self.btnPhoto setUserInteractionEnabled:NO];
        [self.btnDocument1 setUserInteractionEnabled:NO];
        [self.btnDocument2 setUserInteractionEnabled:NO];
        
    }
    else {
        //0-traveler_id, 1-traveler_type, 2-package_id, 3-first_name, 4-last_name, 5-email_id,6- phone_no, 7-title, 8-nationality_id, 9-nationality_name, 10-special_request, 11-image_id, 12-traveler_id, 13-passport_name, 14-passport_image, 15-photo_name, 16-photo_image, 17-doc1_name, 18-doc1_image, 19-doc2_name, 20-doc2_image, 21-isPassportFTP , 22-isPhotoFTP, 23-isDoc1FTP, 24-isDoc2FTP
        
        imageStatusArr = [[NSMutableArray alloc]init];
        imageDataArr = [[NSMutableArray alloc]init];
        imagePathArr = [[NSMutableArray alloc]init];
        _packageId = [self.travelerDetailArr objectAtIndex:2];
        [self.btnHonorifics setTitle:[self.travelerDetailArr objectAtIndex:7] forState:UIControlStateNormal];
        [self.txtFirstName setText:[self.travelerDetailArr objectAtIndex:3]];
        [self.txtLastName setText:[self.travelerDetailArr objectAtIndex:4]];
        [self.btnNationality setTitle:[self.travelerDetailArr objectAtIndex:9] forState:UIControlStateNormal];
        [self.txtEmailId setText:[self.travelerDetailArr objectAtIndex:5]];
        [self.txtPhoneNo setText:[self.travelerDetailArr objectAtIndex:6]];
        [self.txtSpecialRequest setText:[self.travelerDetailArr objectAtIndex:10]];
        
        traveler_id = [self.travelerDetailArr objectAtIndex:0];
        
        [imagePathArr addObject:[self.travelerDetailArr objectAtIndex:13]];
        [imagePathArr addObject:[self.travelerDetailArr objectAtIndex:15]];
        [imagePathArr addObject:[self.travelerDetailArr objectAtIndex:17]];
        [imagePathArr addObject:[self.travelerDetailArr objectAtIndex:19]];
        
        [imageDataArr addObject:[self.travelerDetailArr objectAtIndex:14]];
        [imageDataArr addObject:[self.travelerDetailArr objectAtIndex:16]];
        [imageDataArr addObject:[self.travelerDetailArr objectAtIndex:18]];
        [imageDataArr addObject:[self.travelerDetailArr objectAtIndex:20]];
        
        [imageStatusArr addObject:[self.travelerDetailArr objectAtIndex:21]];
        [imageStatusArr addObject:[self.travelerDetailArr objectAtIndex:22]];
        [imageStatusArr addObject:[self.travelerDetailArr objectAtIndex:23]];
        [imageStatusArr addObject:[self.travelerDetailArr objectAtIndex:24]];
        
        //------ set PASSPORT IMAGE & BUTTON
        if ([self.travelerDetailArr objectAtIndex:14]  != nil) {
            
            [self.imageView1 setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.dbHandler.ImageFolderPath,[self.travelerDetailArr objectAtIndex:14]]]];
            
            if ([[self.travelerDetailArr objectAtIndex:21] integerValue] == 1) {
                [self.btnPassport setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
            }
            else {
                [self.btnPassport setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
                [self.btnPassport setUserInteractionEnabled:YES];
            }
        }
        else {
            
            [self.btnPassport setUserInteractionEnabled:NO];
        }
        
        //------- set PHOTO IMAGE & BUTTON
        if ([self.travelerDetailArr objectAtIndex:16]  != nil) {
            
            [self.imageView2 setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.dbHandler.ImageFolderPath,[self.travelerDetailArr objectAtIndex:16]]]];
            if ([[self.travelerDetailArr objectAtIndex:22] integerValue] == 1) {
                [self.btnPhoto setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
            }
            else {
                [self.btnPhoto setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
                [self.btnPhoto setUserInteractionEnabled:YES];
            }
        }
        else {
            [self.btnPhoto setUserInteractionEnabled:NO];
        }
        
        //------- set DOCUMENT1 IMAGE & BUTTON
        if ([[self.travelerDetailArr objectAtIndex:18] integerValue] != 0) {
            
            [self.imageView3 setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.dbHandler.ImageFolderPath,[self.travelerDetailArr objectAtIndex:18]]]];
            if ([[self.travelerDetailArr objectAtIndex:23] integerValue] == 1) {
                [self.btnDocument1 setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
            }
            else {
                [self.btnDocument1 setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
                [self.btnDocument1 setUserInteractionEnabled:YES];
            }
        }
        else {
            [self.btnDocument1 setUserInteractionEnabled:NO];
        }
        
        //------- set DOCUMENT2 IMAGE & BUTTON
        if ([[self.travelerDetailArr objectAtIndex:18] integerValue] != 0) {
            
            [self.imageView4 setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.dbHandler.ImageFolderPath,[self.travelerDetailArr objectAtIndex:18]]]];
            if ([[self.travelerDetailArr objectAtIndex:24] integerValue] == 1) {
                [self.btnDocument2 setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
            }
            else {
                [self.btnDocument2 setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
                [self.btnDocument2 setUserInteractionEnabled:YES];
            }
        }
        else {
            [self.btnDocument2 setUserInteractionEnabled:NO];
        }
    }
}

-(void)setLayout {
    
    self.tableViewHeightConstant.constant = 52*[otherTravellerArr count];
    
    self.btnAddTraveller.layer.cornerRadius = 25.0f;
    self.btnAddTraveller.layer.borderColor = [UIColor clearColor].CGColor;
    self.btnAddTraveller.layer.borderWidth = 4.0f;
    [self setCardViewForButton:self.btnAddTraveller];
    
    self.btnHonorifics.layer.cornerRadius = 4.0f;
    self.btnSubmit.layer.cornerRadius = 4.0f;
    self.btnNationality.layer.cornerRadius = 4.0f;
    self.view1.layer.cornerRadius = 4.0;
    self.view2.layer.cornerRadius = 4.0;
    self.view4.layer.cornerRadius = 4.0;
    self.view5.layer.cornerRadius = 4.0;
    self.view6.layer.cornerRadius = 4.0;
    self.view7.layer.cornerRadius = 4.0;
    self.view8.layer.cornerRadius = 4.0;
    self.view9.layer.cornerRadius = 4.0;
    self.view10.layer.cornerRadius = 4.0;
    
    [self setCardViewForButton:self.btnNationality];
}
-(void)setTextFieldLayout {
    
    [self setPlaceholderTintColor:self.txtFirstName WithText:@"First Name"];
    [self setPlaceholderTintColor:self.txtLastName WithText:@"Last Name"];
    [self setPlaceholderTintColor:self.txtEmailId WithText:@"Email Id"];
    [self setPlaceholderTintColor:self.txtPhoneNo WithText:@"Phone No"];
    [self setPlaceholderTintColor:self.txtSpecialRequest WithText:@"Special Request"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)setPlaceholderTintColor:(UITextField *)textField WithText:(NSString *)string{
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    
}

-(void)nationalityTouched:(id)sender {
    NSLog(@"TOUCHED");
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

#pragma mark -  NIDropDown Delegate methods

-(void)rel{
    
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self rel];
}

-(void) selectedIndex:(NSInteger)selectedIndex {
    
    strNationalityID = [[nationalityArr objectAtIndex:selectedIndex] objectAtIndex:0];
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddTraveller:(id)sender {
    
    if ([self countTotalTravelerAllowed:_packageId]<[_totalVisaNo integerValue]-1) {
        AddTravellerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_TRAVELLER"];
        viewController.delegate = (id)self;
        viewController.package_id = _packageId;
        [self presentViewController:viewController animated:YES completion:nil];
        

    }
    else {
        [self.view makeToast:@"Maximum traveler details is added for this package."];
    }
}

-(void)setCardViewForButton :(UIButton *)button {
    
    button.layer.masksToBounds = NO;
    button.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    button.layer.shadowRadius = 1;
     
    button.layer.shadowOpacity = 0.7;
  
    button.layer.shadowColor = [UIColor grayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:button.bounds];
    button.imageView.layer.shadowPath = path.CGPath;
    
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [otherTravellerArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=(TravellerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lblTravellerName.text = [[otherTravellerArr objectAtIndex:indexPath.row] objectAtIndex:3];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddTravellerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_TRAVELLER"];
    viewController.travelerDetailArr = [otherTravellerArr objectAtIndex:indexPath.row];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - SUBMIT Process with Database fetching 

- (IBAction)btnSubmit:(id)sender {
    
    NSString *strFirstName = [self.txtFirstName text];
    NSString *strLastName = [self.txtLastName text];
    NSString *strEmailID = [self .txtEmailId text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strSpecialRequest = [self.txtSpecialRequest text];
    
    if (strFirstName.length == 0 || strLastName.length == 0 || strNationalityID.length == 0 || strEmailID.length == 0 || strPhone.length == 0 || strSpecialRequest.length == 0) {
        
        [self.view makeToast:@"Please fill all the fields."];
    }
    else if ([strPhone length]<10 || [strPhone length]>14 ) {
        [self.view makeToast:@"Please Enter valid phone no."];
    }
    else if (![self validateEmail:strEmailID]) {
        
        [self.view makeToast:@"Please Enter valid Email Id."];
    }
    else if ([[imageStatusArr objectAtIndex:0] integerValue]==0 || [[imageStatusArr objectAtIndex:1] integerValue]==0) {
        
        [self.view makeToast:@"Passport and photo are mandatory"];
    }
    else {
        
        [self saveDataToDatabase];
    }
}


- (IBAction)btnHonorifics:(id)sender {
    NSLog(@"CURRENT TITLE --->>%@",[self.btnHonorifics currentTitle]);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Honorifics"
                                                             delegate:(id)self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Mr.",@"Mrs.",@"Miss", nil];
    [actionSheet setTag:1];
    [actionSheet showInView:[self view]];
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([actionSheet tag] == 1) {
        [self.btnHonorifics setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
    }
    else  if([actionSheet tag] == 2) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if(buttonIndex == 0) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}


-(NSInteger) countTotalTravelerAllowed:(NSString *)packageID {
    
    NSString *selectQ = [NSString stringWithFormat:@"select count(*) from travel_detail where package_id='%@'",packageID];
    return [[self.dbHandler MathOperationInTable:selectQ] integerValue];
}

-(void)fetchDataFromDatabase {
    
    NSString *selectOthers = [NSString stringWithFormat:@"select d.*, i.* from travel_detail As d JOIN traveler_images As i ON d.traveler_id = i.traveler_id where d.package_id='%@' AND d.traveler_type='%@'",_packageId,@"0"];
    otherTravellerArr = [self.dbHandler selectAllDataFromTablewithQuery:selectOthers ofColumn:25];
    [self.tableView reloadData];
    self.tableViewHeightConstant.constant = 52*[otherTravellerArr count];
}

-(void)fetchLeadTravlerDataFromDatabase {
    
    NSString *selectOthers = [NSString stringWithFormat:@"select d.*, i.* from travel_detail As d JOIN traveler_images As i ON d.traveler_id = i.traveler_id where d.package_id='%@' AND d.traveler_type='%@'",_packageId,@"1"];
    self.travelerDetailArr = [self.dbHandler selectAllDataFromTablewithQuery:selectOthers ofColumn:25];
    if ([self.travelerDetailArr count] != 0) {
        self.travelerDetailArr = [self.travelerDetailArr objectAtIndex:0];
    }
    
    
}
-(void)getBackFromController:(NSString *)strOtherTravellerName {
 
    NSLog(@"NEW NAME -->> %@",strOtherTravellerName);
    [self fetchDataFromDatabase];
    [self.tableView reloadData];
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

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField != self.txtEmailId) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<50) {
            return YES;
        }
        else
            return NO;
    }
    
    else {
        return  YES;
    }
    
}

-(BOOL) validateEmail:(NSString*) emailString{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    ////NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
}
- (IBAction)btnSelectFile:(id)sender {
    
    buttonTappped = [sender tag];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Camera", @"Photo Gallery", nil];
        [actionSheet setTag:2];
        [actionSheet showInView:[self view]];
        
    } else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSData *webData;
    NSString *strImageName;
    if (buttonTappped == 1) {
        strImageName = [NSString stringWithFormat:@"%@_%@_passportImage.jpg",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],randomString];
        _imageView1.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        webData = UIImagePNGRepresentation(_imageView1.image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:strImageName];
        [webData writeToFile:localFilePath atomically:YES];
        NSLog(@"localFilePath.%@",localFilePath);
        
        fullPath = localFilePath;
        image1 = [UIImage imageWithContentsOfFile:localFilePath];
        [self.btnPassport setUserInteractionEnabled:YES];
    }
    else if (buttonTappped == 2) {
        
        strImageName = [NSString stringWithFormat:@"%@_%@_photoImage.jpg",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],randomString];
        _imageView2.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        webData = UIImagePNGRepresentation(_imageView2.image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:strImageName];
        [webData writeToFile:localFilePath atomically:YES];
        NSLog(@"localFilePath.%@",localFilePath);
        
        fullPath = localFilePath;
        image1 = [UIImage imageWithContentsOfFile:localFilePath];
        [self.btnPhoto setUserInteractionEnabled:YES];
    }
    else if (buttonTappped == 3) {
        
        strImageName = [NSString stringWithFormat:@"%@_%@_doc1Image.jpg",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],randomString];
        _imageView3.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        webData = UIImagePNGRepresentation(_imageView3.image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:strImageName];
        [webData writeToFile:localFilePath atomically:YES];
        NSLog(@"localFilePath.%@",localFilePath);
       
        fullPath = localFilePath;
        image1 = [UIImage imageWithContentsOfFile:localFilePath];
        [self.btnDocument1 setUserInteractionEnabled:YES];
    }
    else if (buttonTappped == 4) {
        
        strImageName = [NSString stringWithFormat:@"%@_%@_doc2Image.jpg",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],randomString];
        
        _imageView4.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        webData = UIImagePNGRepresentation(_imageView4.image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:strImageName];
        [webData writeToFile:localFilePath atomically:YES];
        NSLog(@"localFilePath.%@",localFilePath);
       
        fullPath = localFilePath;
        image1 = [UIImage imageWithContentsOfFile:localFilePath];
        [self.btnDocument2 setUserInteractionEnabled:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [imagePathArr replaceObjectAtIndex:buttonTappped-1 withObject:fullPath];
    [imageDataArr replaceObjectAtIndex:buttonTappped-1 withObject:[NSString stringWithFormat:@"/%@",strImageName]];
    NSLog(@"PATH ARRAY------->>%@",imageDataArr);
    [self uploadImageAtPath:fullPath];
}


#pragma mark - FTP Upload Image methods

-(void) uploadImageAtPath :(NSString *)path {
    
    NSLog(@"fullPAth...... %@",path);
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:FTP_URL] toUploadFile:path];
        
        ftpRequest.username = FTP_USERNAME;
        ftpRequest.password = FTP_PASSWORD;
        //ftpRequest.customUploadFileName = @"ConductCare3.png";
        ftpRequest.delegate = self;
        [ftpRequest startAsynchronous];
        
    });
    
    
}
- (void)ftpRequestWillStart:(SCRFTPRequest *)request
{
    NSLog(@"started");
}

- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status

{
    NSLog(@"didChanged");
}

- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten
{
    // NSLog(@"didWrited");
}
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request

{
    if ([[request filePath] containsString:@"passportImage"]) {
        [self.btnPassport setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:0 withObject:@"1"];
    }
    else if ([[request filePath] containsString:@"photoImage"]) {
        [self.btnPhoto setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:1 withObject:@"1"];
    }
    else if ([[request filePath] containsString:@"doc1Image"]) {
        [self.btnDocument1 setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:2 withObject:@"1"];
    }
    else if ([[request filePath] containsString:@"doc2Image"]) {
        [self.btnDocument2 setImage:[UIImage imageNamed:@"s1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:3 withObject:@"1"];
    }
    
    [self hideHud];
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
    if ([[request filePath] containsString:@"passportImage"]) {
        [self.btnPassport setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:0 withObject:@"0"];
    }
    else if ([[request filePath] containsString:@"photoImage"]) {
        [self.btnPhoto setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:1 withObject:@"0"];
    }
    else if ([[request filePath] containsString:@"doc1Image"]) {
        [self.btnDocument1 setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:2 withObject:@"0"];
    }
    else if ([[request filePath] containsString:@"doc2Image"]) {
        [self.btnDocument2 setImage:[UIImage imageNamed:@"u1.png"] forState:UIControlStateNormal];
        [imageStatusArr replaceObjectAtIndex:3 withObject:@"0"];
    }
    [self hideHud];
}

#pragma mark - Database Insertion

-(void)saveDataToDatabase {
    
    NSString *strFirstName = [self.txtFirstName text];
    NSString *strLastName = [self.txtLastName text];
    NSString *strEmailID = [self .txtEmailId text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strSpecialRequest = [self.txtSpecialRequest text];
    NSString *strTitle = [self.btnHonorifics currentTitle];
    NSString *strPassportPath = [imagePathArr objectAtIndex:0];
    NSString *strPhotoPath = [imagePathArr objectAtIndex:1];
    NSString *strDoc1Path = [imagePathArr objectAtIndex:2];
    NSString *strDoc2Path = [imagePathArr objectAtIndex:3];
    NSString *strNationalityName = [self.btnNationality currentTitle];
    
    
    if ([traveler_id integerValue] != 0) {
        
        NSString *deleteQuery1 =[NSString stringWithFormat:@"delete from travel_detail where traveler_id='%@'",traveler_id];
        [self.dbHandler DeleteDataWithQuesy:deleteQuery1];
        
        NSString *deleteQuery2 =[NSString stringWithFormat:@"delete from traveler_images where traveler_id='%@'",traveler_id];
        [self.dbHandler DeleteDataWithQuesy:deleteQuery2];
    }
    
    NSString *insertQuery = [NSString stringWithFormat:@"insert into travel_detail (package_id,traveler_type,first_name,last_name,email_id,phone_no,title, nationality_id, nationality_name, special_request) values ('%@','%@','%@','%@','%@','%@', '%@', '%@', '%@','%@')",_packageId,[NSNumber numberWithInteger:1],strFirstName,strLastName,strEmailID,strPhone,strTitle, strNationalityID, strNationalityName, strSpecialRequest];
    NSLog(@"----------------%@",insertQuery);
    [self.dbHandler insertDataWithQuesy:insertQuery];
    
    
    NSString *selectQuery=@"SELECT traveler_id FROM travel_detail ORDER BY traveler_id DESC LIMIT 1";
    NSArray *arr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
    NSLog(@"------>> %@",[[arr objectAtIndex:0] objectAtIndex:0]);
    
    
    NSString *insertQuery1 = [NSString stringWithFormat:@"insert into traveler_images (traveler_id,passport_name,passport_image,photo_name,photo_image,doc1_name,doc1_image,doc2_name,doc2_image,isPassportFTP,isPhotoFTP, isDoc1FTP,isDoc2FTP) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[arr objectAtIndex:0] objectAtIndex:0],strPassportPath,[imageDataArr objectAtIndex:0],strPhotoPath,[imageDataArr objectAtIndex:1],strDoc1Path,[imageDataArr objectAtIndex:2],strDoc2Path,[imageDataArr objectAtIndex:3],[NSNumber numberWithInteger:[[imageStatusArr objectAtIndex:0] integerValue]],[NSNumber numberWithInteger:[[imageStatusArr objectAtIndex:1] integerValue]],[NSNumber numberWithInteger:[[imageStatusArr objectAtIndex:2] integerValue]],[NSNumber numberWithInteger:[[imageStatusArr objectAtIndex:3] integerValue]]];
    NSLog(@"----------------%@",insertQuery1);
    [self.dbHandler insertDataWithQuesy:insertQuery1];    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(getBackFromController)])
    {
        [_delegate getBackFromController];
    }
    
}
#pragma mark -MBProgressHUD methods

-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       
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

-(NSMutableArray *)passDAta:(NSMutableArray *)dataArray {
    return dataArray;
}
- (IBAction)btnImageStatus:(id)sender {
    
    if ([[imageStatusArr objectAtIndex:[sender tag]-1] integerValue] == 0) {
        
        [self.view makeToast:[NSString stringWithFormat:@"RETRY >> %@",[imagePathArr objectAtIndex:[sender tag]-1]]];
        [self uploadImageAtPath:[imagePathArr objectAtIndex:[sender tag]-1]];
    }
    else {
        
        [self.view makeToast:@"SUCCESSFUL"];
    }
}

@end
