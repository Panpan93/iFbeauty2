//
//  firstViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface firstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *objectsForShow;
@property (strong, nonatomic) PFObject *hh;
@property (weak, nonatomic) IBOutlet UITableView *scrollVIew;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
