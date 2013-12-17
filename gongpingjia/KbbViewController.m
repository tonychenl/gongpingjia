//
//  KbbViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-17.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "KbbViewController.h"
#import "MianViewController.h"

@interface KbbViewController ()
-(void)calculatePrice;
@end

@implementation KbbViewController

-(void)calculatePrice
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _avgMile = 2100;
    _bFirst = TRUE;
    _city = @"南京";
    
    MianViewController *root = [self.navigationController.viewControllers objectAtIndex:0];
    _brandModel = [root valueForKey:@"brandModel"];
    _modelDic = [root valueForKey:@"modelDic"];
    _sytelDic = [root valueForKey:@"sytelDic"];

    NSString  *model_img_path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"assets"] stringByAppendingPathComponent:@"model_img"];
    
    __weak NSString *img = [_modelDic valueForKey:@"thumbnail"];
    NSString *img_path = nil;
    if ([img isKindOfClass:[NSNull class]]) {
        img_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"carnull.jpg"];
    }else{
        img_path = [model_img_path stringByAppendingPathComponent:img];
        if (![[NSFileManager defaultManager] fileExistsAtPath:img_path]) {
            img_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"carnull.jpg"];
        }
    }
    
    UIImage *modelImg = [[UIImage alloc] initWithContentsOfFile:img_path];
    UIImage *logImg = [[UIImage alloc] initWithContentsOfFile:_brandModel.logo_img];
    self.brandImg.image = logImg;
    self.modelImg.image = modelImg;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY年"];
    self.year.text = [formater stringFromDate:root.date];
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
