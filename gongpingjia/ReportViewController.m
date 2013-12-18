//
//  ReportViewController.m
//  gongpingjia
//
//  Created by yt on 13-12-18.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "ReportViewController.h"
#import "MianViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    mCPTXYGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [mCPTXYGraph applyTheme:theme];
    CPTGraphHostingView *hostingview = (CPTGraphHostingView *)self.yearCompare;
    hostingview.hostedGraph = mCPTXYGraph;
    
    // Border
    mCPTXYGraph.plotAreaFrame.borderLineStyle = nil;
    mCPTXYGraph.plotAreaFrame.cornerRadius    = 0.0f;
    mCPTXYGraph.plotAreaFrame.masksToBorder   = NO;
    
    // Paddings
    mCPTXYGraph.paddingLeft   = 0.0f;
    mCPTXYGraph.paddingRight  = 0.0f;
    mCPTXYGraph.paddingTop    = 0.0f;
    mCPTXYGraph.paddingBottom = 0.0f;
    
    mCPTXYGraph.plotAreaFrame.paddingLeft   = 45.0;
    mCPTXYGraph.plotAreaFrame.paddingTop    = 10.0;
    mCPTXYGraph.plotAreaFrame.paddingRight  = 20.0;
    mCPTXYGraph.plotAreaFrame.paddingBottom = 25.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)mCPTXYGraph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(300.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(16.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)mCPTXYGraph.axisSet;

    CPTXYAxis *x = axisSet.xAxis;
    //x.axisLineStyle = lineStyle;
    //x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromFloat(5.0f);
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.title = @"年代";
    
    CPTXYAxis *y = axisSet.yAxis;
    //y.axisLineStyle               = nil;
    //y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"100");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");

    CPTBarPlot *barPlot     = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barOffset       = CPTDecimalFromFloat(0.25f);
    barPlot.barCornerRadius = 2.0f;
    barPlot.identifier      = @"Bar Plot 2";
    [mCPTXYGraph addPlot:barPlot toPlotSpace:plotSpace];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [formater setDateFormat:@"YYYY"];
    _modelYear = [formater stringFromDate:root.date];
    
    [self performSelector:@selector(loaddata) withObject:nil];
}

-(void)loaddata
{
    [SVProgressHUD showWithStatus:@"loading...."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://www.gongpingjia.com/mobile/cars/price-report/?brand_slug=%@&model_slug=%@&year=%@",
                     _brandModel.slug,
                     [_modelDic valueForKey:@"slug"],
                     _modelYear];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            static NSString *success = @"success";
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqual:success]) {
                self.price.text = [NSString stringWithFormat:@"￥%@",[responseObject objectForKey:@"avg_price"]];
                self.betweenPrice.text = [NSString stringWithFormat:@"￥%@-%@",[responseObject objectForKey:@"price_range_min"],[responseObject objectForKey:@"price_range_max"]];
                
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

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 6;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
                break;
                
            case CPTBarPlotFieldBarTip:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 1) * (index + 1)];
                if ( [plot.identifier isEqual:@"Bar Plot 2"] ) {
                    num = [num decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"10"]];
                }
                break;
        }
    }
    
    return num;
}

@end
