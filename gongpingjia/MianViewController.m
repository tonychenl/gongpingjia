//
//  ViewController.m
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "MianViewController.h"

@interface MianViewController ()
-(void)setDateLabel:(NSDate*)date;
@end

@implementation MianViewController

-(void)setCarModel
{
    UILabel *mLable = (UILabel *)[self.tableView viewWithTag:110];
    UILabel *mStyle = (UILabel *)[self.tableView viewWithTag:111];
    NSString *modelStr = [NSString stringWithFormat:@"%@ %@",brandModel.name,[modelDic valueForKey:@"name"]];
    mLable.text = modelStr;
    mStyle.text = [sytelDic valueForKey:@"desc"];
}

-(void)brandModel:(BrandModel *)brand model:(NSDictionary *)model sytel:(NSDictionary *)style
{
    brandModel = brand;
    modelDic = model;
    sytelDic = style;
    [self setCarModel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //actionsheet
    dateActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    [toolBar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick:)];
    [barItems addObject:doneBtn];
    [toolBar setItems:barItems animated:YES];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [dateActionSheet addSubview:toolBar];
    [dateActionSheet addSubview:datePicker];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //init
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell  *cell = [self.tableView cellForRowAtIndexPath:path];
    dateLabel = (UILabel*)[cell viewWithTag:101];
    if (self.date == nil) {
        self.date = [datePicker date];
        [self setDateLabel:[NSDate date]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    milage = [textField text];
    NSLog(@"%@",milage);
    [textField resignFirstResponder];
    return NO;
}

-(void)DatePickerDoneClick:(id)sender
{
    self.date = [datePicker date];
    [self setDateLabel:self.date];
    [dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section]==0 && [indexPath row] == 0) { //选择上牌日期
        [dateActionSheet showInView:self.view];
        [dateActionSheet setBounds:CGRectMake(0, 0, 320, 464)];
        return;
    }
}

-(void)setDateLabel:(NSDate *)datex
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"YYYY年MM月"];
    dateLabel.text = [f stringFromDate:datex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 检查选择参数
*/
-(BOOL)checkChoose
{
    if (brandModel == nil || modelDic == nil ||  sytelDic == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请选择车型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
