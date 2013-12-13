//
//  BrandCell.h
//  gongpingjia
//
//  Created by yt on 13-12-13.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@interface BrandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo_img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) BrandModel *brandModel;
@end
