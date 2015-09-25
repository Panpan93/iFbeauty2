//
//  postViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface postViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *postTable;
@property(strong,nonatomic)NSArray *postArray;

@end
