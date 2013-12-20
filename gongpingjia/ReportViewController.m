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

-(void)drawYearReport
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
    
    mCPTXYGraph.plotAreaFrame.paddingLeft   = 30.0;
    mCPTXYGraph.plotAreaFrame.paddingTop    = 10.0;
    mCPTXYGraph.plotAreaFrame.paddingRight  = 20.0;
    mCPTXYGraph.plotAreaFrame.paddingBottom = 17.0;
    
    float xLength =  [[mYearReportDic valueForKey:@"svg_rect_data_num"] floatValue] + 0.5f;
    NSArray *avgPrice = [mYearReportDic valueForKey:@"svg_rect_data_avg_price"];
    float count = 0.0f;
    for (NSString *value in avgPrice) {
        count += [value floatValue];
    }
    
    float max = (count / [[mYearReportDic valueForKey:@"svg_rect_data_num"] floatValue]) * 2.0;
    
    float xx = max / 3.0;
    
    int abc = 10;
    float tmp = xx;
    int index = 1;
    
    if (tmp<=10.0f) {
        tmp = 5.0f;
    }else{
        while (tmp>10.0f) {
            tmp /=abc;
            if (tmp<=10.0f) {
                break;
            }
            index++;
        }
        int a = ceil(tmp);
        int p = index == 1 ?10:pow(10, index);
        tmp = a * p;

    }
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)mCPTXYGraph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(tmp * 3.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(xLength)];
    
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)mCPTXYGraph.axisSet;
    
    CPTXYAxis *x = axisSet.xAxis;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [ CPTColor grayColor ];
    textStyle.fontSize = 8.0f ;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor grayColor];
    lineStyle.lineWidth = 1.0f;
    
    x.titleTextStyle = textStyle;
    x.labelTextStyle = textStyle;
    x.minorTickLineStyle = nil;
    x.majorTickLineStyle = lineStyle;
    //x.majorGridLineStyle = lineStyle;
    x.axisLineStyle = lineStyle;
    x.majorIntervalLength = CPTDecimalFromFloat(1.0f);
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");

    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0], [NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4],[NSDecimalNumber numberWithInt:5],[NSDecimalNumber numberWithInt:6],nil];
    NSArray *dateYear = [mYearReportDic valueForKey:@"svg_rect_data_year"];
    NSMutableArray *xAxisLabels         = [NSMutableArray arrayWithArray:dateYear];
    [xAxisLabels insertObject:@"" atIndex:0];
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = x.labelOffset;// + x.majorTickLength;
        //newLabel.rotation     = M_PI / 4;
        [customLabels addObject:newLabel];
    }
    x.axisLabels = [NSSet setWithArray:customLabels];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.titleTextStyle = textStyle;
    y.labelTextStyle = textStyle;
    y.minorTickLineStyle = nil;
    y.majorTickLineStyle = lineStyle;
    //x.majorGridLineStyle = lineStyle;
    y.axisLineStyle = lineStyle;
    y.majorIntervalLength         = CPTDecimalFromFloat(tmp);
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
    CPTColor *color = [CPTColor colorWithComponentRed:14.0f green:13.0f blue:123.0f alpha:1.0f];
    CPTBarPlot *barPlot     = [CPTBarPlot tubularBarPlotWithColor:color horizontalBars:NO];
    barPlot.dataSource      = self;
    //barPlot.baseValue       = CPTDecimalFromString(@"1.5f");
    //barPlot.barOffset       = CPTDecimalFromFloat(10.0f);
    barPlot.barCornerRadius = 0.0f;
    barPlot.labelOffset = 1.0f;
    //barPlot.barWidth = [[NSDecimalNumber numberWithFloat:0.5f] decimalValue];
    barPlot.barWidthScale = 0.8f;
    
    barPlot.identifier      = @"Bar Plot 2";
    [mCPTXYGraph addPlot:barPlot toPlotSpace:plotSpace];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self performSelector:@selector(loaddata) withObject:nil];
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
                mYearReportDic = responseObject;
                [self drawYearReport];
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
    int xLength =  [[mYearReportDic valueForKey:@"svg_rect_data_num"] floatValue] + 1.0f;
    return xLength;
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
                if (index==0) {
                    return [NSNumber numberWithFloat:0.0f];
                }
                if ( [plot.identifier isEqual:@"Bar Plot 2"] ) {
                    //num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:[num integerValue] * 100];
                    NSArray *avgPrice = [mYearReportDic valueForKey:@"svg_rect_data_avg_price"];
                    NSInteger price = [[avgPrice objectAtIndex:index-1] integerValue];
                    return [NSNumber numberWithInteger:price];
                }
                break;
        }
    }
    
    return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    if (idx == 0) {
        return nil;
    }
    NSArray *avgPrice = [mYearReportDic valueForKey:@"svg_rect_data_avg_price"];
    float price = [[avgPrice objectAtIndex:idx-1] floatValue];
    CPTTextLayer *label            = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.1f", price]];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor lightGrayColor];
    label.textStyle = textStyle;
    return label;
    
}

@end
