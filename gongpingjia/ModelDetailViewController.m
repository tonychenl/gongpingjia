//
//  ModelDetailViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-13.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "ModelDetailViewController.h"
#import "MianViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "SVProgressHUD.h"

@interface ModelDetailViewController ()

@end

@implementation ModelDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)brandModel:(BrandModel *)model modelDic:(NSDictionary *)dic{
    brandModel = model;
    modelDic = dic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[modelDic valueForKey:@"name"]];
    dataDic = [[NSMutableDictionary alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    MianViewController *view  = (MianViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD showWithStatus:@"loading..." maskType:SVProgressHUDMaskTypeGradient];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"YYYY"];
    NSString *url = [NSString stringWithFormat:@"http://nj.gongpingjia.com/mobile/cars/get-detail-model/?model_slug=%@&year=%@",[modelDic valueForKey:@"slug"],[f stringFromDate:view.date]];
    NSLog(@"%@",url);
    [manager GET:url parameters:Nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 static NSString *success = @"success";
                 NSString *status = [responseObject valueForKey:@"status"];
                 if ([status isEqual:success]) {
                     NSDictionary *tmpdic = [responseObject valueForKey:@"result"];
                     dataDic = tmpdic;
                     NSArray *tmpKey = [[NSArray alloc] initWithArray:[tmpdic allKeys]];
                     dataKey = [tmpKey sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         NSInteger y1 = [obj1 integerValue];
                         NSInteger y2 = [obj2 integerValue];
                         if (y1 == y2) {
                             return (NSComparisonResult)NSOrderedSame;
                         }
                         if (y1 > y2) {
                             return (NSComparisonResult)NSOrderedAscending;
                         }
                         return (NSComparisonResult)NSOrderedDescending;
                     }];
                     [self.tableView  reloadData];
                     [SVProgressHUD showSuccessWithStatus:@"Success"];
                 }else{
                     [SVProgressHUD showErrorWithStatus:@"未找到符合条件的车型"];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }else{
                 [SVProgressHUD showErrorWithStatus:@"未找到符合条件的车型"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"Error"];
             [self.navigationController popViewControllerAnimated:YES];
         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataKey count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [dataKey objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString  *key = [dataKey objectAtIndex:section];
    return [[dataDic valueForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"xinghaocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *text = (UILabel*)[cell viewWithTag:101];
    UILabel *model = (UILabel*)[cell viewWithTag:102];
    
    NSString  *key = [dataKey objectAtIndex:[indexPath section]];
    NSDictionary *tDic =  [dataDic objectForKey:key];
    NSString  *mKey = [[tDic allKeys] objectAtIndex:[indexPath row]];
    model.text = mKey;
    text.text = [tDic valueForKey:mKey];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *text = (UILabel*)[cell viewWithTag:101];
    UILabel *model = (UILabel*)[cell viewWithTag:102];
    NSDictionary *styleDic = [NSDictionary dictionaryWithObjectsAndKeys:text.text,@"desc",model.text,@"style",nil];
    
    MianViewController *view  = (MianViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [view brandModel:brandModel model:modelDic sytel:styleDic];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
