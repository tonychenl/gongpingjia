//
//  ModelViewController.h
//  gongpingjia
//
//  Created by yt on 13-12-13.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@interface ModelViewController : UITableViewController
{
    __weak NSArray *models;
}
@property (weak,nonatomic)BrandModel *brandModel;
@end
