//
//  GujiaSegue.m
//  gongpingjia
//
//  Created by yt on 13-12-17.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import "GujiaSegue.h"
#import "MianViewController.h"
#import "BrandModel.h"

@implementation GujiaSegue

-(void)perform
{
    MianViewController *source = self.sourceViewController;
    if (source.checkChoose) {
        UIViewController *view = self.destinationViewController;
        BrandModel *brand = [source valueForKey:@"brandModel"];
        view.title = brand.name;
        [source.navigationController pushViewController:self.destinationViewController animated:YES];
        NSLog(@"xx");
    }
}

@end
