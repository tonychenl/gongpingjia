//
//  KbbViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-17.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "KbbViewController.h"
#import "MianViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

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
    self.modelName.text = [_modelDic valueForKey:@"name"];
    self.styleName.text = [_sytelDic valueForKey:@"desc"];
    
    //init data
    _mBrandSlug = _brandModel.slug;
    _mBrandName = _brandModel.name;
    _mModelSlug = [_modelDic valueForKey:@"slug"];
    _mModelName = [_modelDic valueForKey:@"name"];
    [formater setDateFormat:@"YYYY"];
    _mModelYear = [formater stringFromDate:root.date];
    _mModelMile = [root valueForKey:@"milage"] == nil ? @"0" : [root valueForKey:@"milage"];
    _mModelDetailSlug = [_sytelDic valueForKey:@"style"];
    _mModelDetailName = [_sytelDic valueForKey:@"desc"];
    
    self.mliage.text = _mModelMile;
    //self.mliSlider.value = [_mModelMile intValue];
    
    
    [self performSelector:@selector(loaddata) withObject:nil];
}

-(void)loaddata
{
    [SVProgressHUD showWithStatus:@"loading...."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://nj.gongpingjia.com/mobile/cars/get-kbb-report/?model_slug=%@&year=%@&d_model_slug=%@&mileage=%@",_mModelSlug,_mModelYear,_mModelDetailSlug,_mModelMile];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            static NSString *success = @"success";
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqual:success]) {
                NSDictionary *tmpdic = [responseObject valueForKey:@"current_Qurey"];
                _currentYear = [[tmpdic objectForKey:@"current_year"] integerValue];
                _listPrice = [[tmpdic objectForKey:@"list_price"] integerValue];
                _privatePartyPriceLow = [[tmpdic objectForKey:@"private_party_price_low"] integerValue];
                _privatePartyPriceHigh = [[tmpdic objectForKey:@"private_party_price_high"] integerValue];
                _tradeInPrice = [[tmpdic objectForKey:@"trade_in_price"] integerValue];
                _privatePartyPrice = [[tmpdic objectForKey:@"private_party_price"] integerValue];
                _modelUnits = [[tmpdic objectForKey:@"model_units"] integerValue];
                _basePrice = [[tmpdic objectForKey:@"base_price"] integerValue];
                _optionPrice = [[tmpdic objectForKey:@"option_price"] integerValue];
                _marketPrice = [[tmpdic objectForKey:@"market_price"] integerValue];
                _marketLowPrice = [[tmpdic objectForKey:@"market_low_price"] integerValue];
                _marketHighPrice = [[tmpdic objectForKey:@"market_high_price"] integerValue];
                _avgMile = [[tmpdic objectForKey:@"avg_mile"] integerValue];
                _saleLimit = [[tmpdic objectForKey:@"sale_limit"] integerValue];
                _tradeInLimit = [[tmpdic objectForKey:@"tradein_limit"] integerValue];
                _saleRate = [[tmpdic objectForKey:@"sale_rate"] floatValue];
                _tradeInRate = [[tmpdic objectForKey:@"trade_in_rate"] floatValue];
                _city = [responseObject objectForKey:@"current_city"];
                
                
                _mListPrice = _listPrice;
                _mPrivatePartyPrice = _privatePartyPrice;
                _mTradeInPrice = _tradeInPrice;
                
                if ([@"0" isEqualToString:_mModelMile]) {
                    _mModelMile = [NSString stringWithFormat:@"%dl",_avgMile];
                }
                
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务器错误"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"连接服务器出错"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
