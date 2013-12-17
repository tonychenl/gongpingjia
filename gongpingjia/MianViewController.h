//
//  ViewController.h
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@interface MianViewController : UITableViewController<UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *milage;
    UILabel  *dateLabel;
    UIActionSheet *dateActionSheet;
    UIDatePicker  *datePicker;
    BrandModel *brandModel;
    NSDictionary *modelDic;
    NSDictionary *sytelDic;
}
@property(strong,nonatomic) NSDate *date;
-(void)brandModel:(BrandModel *)brand model:(NSDictionary*) model sytel:(NSDictionary*)style;

-(BOOL)checkChoose;
@end
