//
//  postDetailViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/10.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *zan;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *shijian1;
@property (weak, nonatomic) IBOutlet UILabel *postdetail;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *zanItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shoucangItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentItem;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray * objectArray;
@property (strong, nonatomic) PFObject *chuanru;
@property (strong, nonatomic) PFObject *item;

@end
