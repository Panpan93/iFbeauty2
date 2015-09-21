//
//  MineViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/20.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;//头像
@property (weak, nonatomic) IBOutlet UILabel *usernameLB;//名称
@property (weak, nonatomic) IBOutlet UILabel *signature;//签名
@property (weak, nonatomic) IBOutlet UILabel *post;//帖子
@property (weak, nonatomic) IBOutlet UILabel *focus;//关注
@property (weak, nonatomic) IBOutlet UILabel *fans;//粉丝
@property (weak, nonatomic) IBOutlet UITableView *tableIV;//tableview
@property (strong,nonatomic)NSMutableArray *objectforshow;
@end
