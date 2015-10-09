//
//  commentViewController.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentViewController : UIViewController
- (IBAction)deleteButtenItem:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *deLabel;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (strong, nonatomic) PFObject *commentobject;
@property (strong, nonatomic) PFObject *commentItem;

@property (strong, nonatomic) NSArray *objectsForShow;


@end
