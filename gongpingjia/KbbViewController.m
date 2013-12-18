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
-(void)updateView;
@end

@implementation KbbViewController

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
    _mUserCondition = @"较好";
    
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
    CALayer *layer = [self.modelImg layer];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
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
                _saleRate = [[tmpdic objectForKey:@"sale_rate"] doubleValue];
                _tradeInRate = [[tmpdic objectForKey:@"trade_in_rate"] doubleValue];
                _city = [responseObject objectForKey:@"current_city"];
                
                
                _mListPrice = _listPrice;
                _mPrivatePartyPrice = _privatePartyPrice;
                _mTradeInPrice = _tradeInPrice;
                
                if ([@"0" isEqualToString:_mModelMile]) {
                    _mModelMile = [NSString stringWithFormat:@"%dl",_avgMile];
                }
                
                _mUserMile = [_mModelMile integerValue];
                double d = 100.0 * (_mUserMile/(float)_tradeInLimit);
                self.mliSlider.value = (int)d;
                
                [self calculatePrice];
                [self updateView];
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
    if (_bFirst) {
        _bFirst = FALSE;
        return;
    }
    double d = self.mliSlider.value/self.mliSlider.maximumValue;
    _mUserMile = (int)(d * _tradeInLimit);
    [self calculatePrice];
    [self updateView];
}

- (IBAction)statusChange:(id)sender {
    UISlider *slider = (UISlider*)sender;
    double d1 = slider.value;
    double d2 = slider.maximumValue;
    double d3 = 100.0f * (d1/d2);
    if (d3 < 33.0f) {
        _mUserCondition = @"一般";
        self.statusSlider.value = 0;
    }else if (d3 > 66.0f) {
        _mUserCondition = @"优秀";
        self.statusSlider.value = (int)d2;
    }else{
        _mUserCondition = @"较好";
        self.statusSlider.value = (int)(d2/2.0f);
    }
    [self calculatePrice];
    [self updateView];
}

-(void)calculatePrice
{
    _mListPrice = (int)(0.9f * _basePrice);
    double d1 = _mUserMile;
    double d2 = 0.5f * (1.0f + (d1 - _avgMile)/(float)(_avgMile-_tradeInLimit));
    if (d2 < 0.0f) {
        d2 = 0.0f;
    }
    _mListPrice = (int)(_mListPrice + d2 * (0.2f * _basePrice));
    _mListPrice += _optionPrice;
    if ([@"一般" isEqualToString:_mUserCondition]) {
        _mListPrice = (int)(0.913f * _mListPrice);
    }
    if ([_mUserCondition isEqualToString:@"优秀"]) {
        _mListPrice = (int)(1.059f * _mListPrice);
    }
    
    double d3 = 0.03f;
    //if (d1 < _saleLimit) {
        d3 += 0.05f * (1.0f - d1 / _saleLimit);
    //}
    _mPrivatePartyPrice = (int)((float)_mListPrice / (1.0f + d3));
    
    double d4 = 0.08f;
    if (d1 < _tradeInLimit) {
        d4 += 0.08f * (1.0f - d1 / (float)_tradeInLimit);
    }
    _mTradeInPrice = (int)((float)_mListPrice/(1.0f + d4));
    
}

-(void)updateView
{
    self.price.text = [NSString stringWithFormat:@"￥%d",_mPrivatePartyPrice];
    self.price1.text = self.price.text;
    self.mliLabel.text = [NSString stringWithFormat:@"您车的里程数：%d公里",_mUserMile];
    self.mliage.text = [NSString stringWithFormat:@"%d公里",_mUserMile];
    self.statusLabel.text = [NSString stringWithFormat:@"您车的车况：%@",_mUserCondition];
    self.makertMaxPrice.text = [NSString stringWithFormat:@"￥%d",_marketHighPrice];
    self.makertAvgPrice.text = [NSString stringWithFormat:@"￥%d",_marketPrice];
    self.makertMinPrice.text = [NSString stringWithFormat:@"￥%d",_marketLowPrice];
    self.changePrice.text = [NSString stringWithFormat:@"￥%d",_mTradeInPrice];
    self.suggestPrice.text = [NSString stringWithFormat:@"￥%d",_mListPrice];
}
@end
