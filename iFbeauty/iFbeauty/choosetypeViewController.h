//
//  choosetypeViewController.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/21.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface choosetypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *objectsForShow;

@end
