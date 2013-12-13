//
//  ViewController.h
//  gongpingjia
//
//  Created by chen liang on 13-12-12.
//  Copyright (c) 2013年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MianViewController : UITableViewController<UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *milage;
    UILabel  *dateLabel;
    UIActionSheet *dateActionSheet;
    UIDatePicker  *datePicker;
}
@property(strong,nonatomic) NSDate *date;
@end
