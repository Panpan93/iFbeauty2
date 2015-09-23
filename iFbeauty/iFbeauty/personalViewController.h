//
//  personalViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/22.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isedit;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *uName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *objectviewshow;
@property(strong,nonatomic)NSMutableArray *objectArray;

@property (weak, nonatomic) IBOutlet UIButton *button;
@end
