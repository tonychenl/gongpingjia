//
//  KbbViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-17.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "KbbViewController.h"

@interface KbbViewController ()
-(void)calculatePrice;
@end

@implementation KbbViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _avgMile = 2100;
        _bFirst = TRUE;
        _city = @"南京";
    }
    return self;
}

-(void)calculatePrice
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mliChange:(id)sender {
}

- (IBAction)statusChange:(id)sender {
}
@end
