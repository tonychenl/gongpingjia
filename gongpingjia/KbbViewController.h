//
//  KbbViewController.h
//  gongpingjia
//
//  Created by yt on 13-12-17.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@interface KbbViewController : UIViewController
{
@private
    NSInteger _avgMile;
    BOOL      _bFirst;
    NSInteger _basePrice;
    NSString  *_city;
    NSInteger _currentYear;
    NSInteger _listPrice;
    NSString  *_mBrandName;
    NSString  *_mBrandSlug;
    NSInteger _mListPrice;
    NSString  *_mModelDetailName;
    NSString  *_mModelDetailSlug;
    NSString  *_mModelMile;
    NSString  *_mModelName;
    NSString  *_mModelYear;
    NSString  *_mModelSlug;
    NSInteger _mPrivatePartyPrice;
    NSInteger _mTradeInPrice;
    NSString  *_mUserCondition;
    NSInteger _mUserMile;
    NSInteger _marketHighPrice;
    NSInteger _marketLowPrice;
    NSInteger _marketPrice;
    NSInteger _modelUnits;
    NSInteger _optionPrice;
    NSInteger _privatePartyPrice;
    NSInteger _privatePartyPriceHigh;
    NSInteger _privatePartyPriceLow;
    NSInteger _saleLimit;
    double     _saleRate;
    NSInteger _tradeInPrice;
    double    _tradeInRate;
    NSInteger _tradeInLimit;
    
    BrandModel   *_brandModel;
    NSDictionary *_modelDic;
    NSDictionary *_sytelDic;
}

@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *modelImg;
@property (weak, nonatomic) IBOutlet UILabel *modelName;
@property (weak, nonatomic) IBOutlet UILabel *styleName;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *mliage;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *mliLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)mliChange:(id)sender;
- (IBAction)statusChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *mliSlider;
@property (weak, nonatomic) IBOutlet UISlider *statusSlider;

@property (weak, nonatomic) IBOutlet UILabel *makertMaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *makertMinPrice;
@property (weak, nonatomic) IBOutlet UILabel *makertAvgPrice;
@property (weak, nonatomic) IBOutlet UILabel *changePrice;
@property (weak, nonatomic) IBOutlet UILabel *suggestPrice;

@end
