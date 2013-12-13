//
//  ModelDetailViewController.h
//  gongpingjia
//
//  Created by yt on 13-12-13.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@interface ModelDetailViewController : UITableViewController
{
    BrandModel *brandModel;
    NSDictionary *modelDic;
}
-(void)brandModel:(BrandModel*) model modelDic:(NSDictionary*) dic;
@end
