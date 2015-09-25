//
//  deleteViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface deleteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *deleteTV;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *deLabel;
@property (weak, nonatomic) IBOutlet UIImageView *particularsIV;
@property (weak, nonatomic) IBOutlet UIView *header;

@property (weak, nonatomic) IBOutlet UILabel *like;

@property (weak, nonatomic) IBOutlet UILabel *commen;
- (IBAction)deleteButtenItem:(id)sender;
@property (strong, nonatomic) PFObject *item;
@property (strong, nonatomic) PFObject *ownername;
@property (strong, nonatomic) NSArray *objectsForShow;

@end
