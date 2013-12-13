//
//  ModelViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-13.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "ModelViewController.h"
#import "AppDelegate.h"
#import "ModelDetailViewController.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.brandModel.name;
    
    models = [[((AppDelegate*)[[UIApplication sharedApplication] delegate]) car_model] objectForKey:self.brandModel.slug];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"model_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    UILabel  *name = (UILabel *)[cell viewWithTag:102];
    __weak NSDictionary *dic = [models objectAtIndex:[indexPath row]];
    name.text = [dic valueForKey:@"name"];
    NSString *model_path_dir = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"assets"] stringByAppendingPathComponent:@"model_img"];
    __weak NSString *img = [dic valueForKey:@"thumbnail"];
    if ([img isKindOfClass:[NSNull class]]) {
        img = @"placeholder.png";
    }
    
    NSString *img_path = [model_path_dir stringByAppendingPathComponent:img];
    if (![[NSFileManager defaultManager] fileExistsAtPath:img_path]) {
        img_path = [model_path_dir stringByAppendingPathComponent:@"placeholder.png"];
    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:img_path];
    imageView.image = image;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *dic = [models objectAtIndex:[indexPath row]];
    id destination = segue.destinationViewController;
    if ([destination isKindOfClass:[ModelDetailViewController class]]) {
        [((ModelDetailViewController*)destination) brandModel:self.brandModel  modelDic:dic];
    }
}

 

@end
