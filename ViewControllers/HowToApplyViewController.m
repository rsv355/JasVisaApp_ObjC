//
//  HowToApplyViewController.m
//  JasVisaApp
//
//  Created by Masum Chauhan on 24/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#import "HowToApplyViewController.h"
#import "VisaDetailTableViewCell.h"
#import "NSString+HTML.h"

@interface HowToApplyViewController ()
{
    VisaDetailTableViewCell *cell;
  
}
@end

@implementation HowToApplyViewController
@synthesize dataDict;

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
     NSLog(@"DATA DICT----->>%@",dataDict);
    //dataDict = [[NSMutableDictionary alloc] init];
    [self initialization];
    self.expandableTableView.estimatedRowHeight = 85.0;
    self.expandableTableView.rowHeight = UITableViewAutomaticDimension;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Initialization

-(void)initialization
{
    arrayForBool=[[NSMutableArray alloc]init];
    arrayForImage=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"How To Apply",
                       @"Special Notes",
                       @"Rates",
                       nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++) {

        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        [arrayForImage addObject:@"ic_up.png"];
    }
   /* NSArray *ary1=[[NSArray alloc]initWithObjects:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", nil];
   // [dataDict setObject:ary1 forKey:@"How To Apply"];
    
    NSArray *ary2=[[NSArray alloc]initWithObjects:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", nil];
    //[dataDict setObject:ary2 forKey:@"Special Notes"];
    
    NSArray *ary3=[[NSArray alloc]initWithObjects:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", nil];
    //[dataDict setObject:ary3 forKey:@"Rates"];
    
   */
    
}
#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
       
        return [[dataDict objectForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid=@"Cell";
    cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.lblVisaDetail.text=@"";
    }
   
    /********** If the section supposed to be Opened *******************/
    
    else
    {
     
        NSString *htmlString = [[dataDict objectForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        NSString *str=[htmlString stringByDecodingHTMLEntities];
        [cell.lblVisaDetail setText:str];
       
        htmlString = [@"<div style='text-align:justify; font-size:12px;font-family:Helvetica;color:#362932;'>" stringByAppendingString:htmlString];
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        cell.lblVisaDetail.attributedText = attributedString;

    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    [arrayForImage replaceObjectAtIndex:indexPath.section withObject:@"ic_down.png"];
    
    [_expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
     
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
//        return 150;
//    }
//    return 0;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,60)];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 5, _expandableTableView.frame.size.width-16, 55)];
    viewLabel.backgroundColor=[UIColor colorWithRed:(229/255.0) green:(229/255.0) blue:(229/255.0) alpha:1.0];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont fontWithName:@"Roboto-Medium" size:17];
    viewLabel.layer.borderWidth = 1.5f;
    viewLabel.layer.borderColor = [UIColor colorWithRed:(246/255.0) green:(192/255.0) blue:(51/255.0) alpha:1.0].CGColor;

    viewLabel.text=[NSString stringWithFormat:@"   %@",[sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:viewLabel];
    
    /**************Add a image in sectionview**************/
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(_expandableTableView.frame.size.width-40, 18,  28, 28)];
    iv.image=[UIImage imageNamed:[arrayForImage objectAtIndex:section]];
    iv.alpha=0.8f;
    [sectionView addSubview:iv];
    
       UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
  
    return  sectionView;
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                if (collapsed==YES) {
                    [arrayForImage replaceObjectAtIndex:i withObject:@"ic_up.png"];
                }
                else{
                    [arrayForImage replaceObjectAtIndex:i withObject:@"ic_down.png"];
                }
            }
        }
        [_expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
}

@end
