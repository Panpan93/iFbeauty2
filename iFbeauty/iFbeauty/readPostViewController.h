//
//  readPostViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface readPostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *readTable;
@property(strong,nonatomic)NSArray *objectShow;

@property (strong, nonatomic) PFObject *chuanru;


@end
