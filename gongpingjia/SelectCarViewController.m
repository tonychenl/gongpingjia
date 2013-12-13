//
//  SelectCarViewController.m
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "SelectCarViewController.h"
#import "BrandModel.h"
#import "BrandCell.h"
#import "AppDelegate.h"

@interface SelectCarViewController ()

@end

@implementation SelectCarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    brand_letter = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) brand_first_letter];
    brands  = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) brand_content];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [brand_letter count];
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return brand_letter;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [brand_letter objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[brands objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"brandcar";
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BrandModel *model = [[brands objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    cell.name.text = model.name;
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:model.logo_img];
    cell.logo_img.image = image;
    cell.brandModel = model;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BrandCell *cell = (BrandCell*)sender;
    id  viewController = segue.destinationViewController;
    if ([viewController respondsToSelector:@selector(setBrandModel:)]) {
        [viewController setValue:cell.brandModel forKey:@"brandModel"];
    }
}

@end
