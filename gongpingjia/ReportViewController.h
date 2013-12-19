//
//  ReportViewController.h
//  gongpingjia
//
//  Created by yt on 13-12-18.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"
#import "CorePlot-CocoaTouch.h"


@interface ReportViewController : UIViewController<CPTPlotDataSource>
{
    BrandModel   *_brandModel;
    NSDictionary *_modelDic;
    NSDictionary *_sytelDic;
    NSString     *_modelYear;
    
@private
    CPTXYGraph   *mCPTXYGraph;
    NSDictionary *mYearReportDic;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *modelImg;
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UILabel *modelName;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *betweenPrice;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *yearCompare;

@end
