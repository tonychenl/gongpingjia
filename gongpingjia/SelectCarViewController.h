//
//  SelectCarViewController.h
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *brand_letter;
    NSArray *brands;
}

@end
