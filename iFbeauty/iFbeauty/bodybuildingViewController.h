//
//  bodybuildingViewController.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bodybuildingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *objectsForShow;
@property (weak, nonatomic) IBOutlet UITableView *bodybuildingTV;
@end
