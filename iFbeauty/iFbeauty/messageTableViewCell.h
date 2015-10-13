//
//  messageTableViewCell.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/22.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageTableViewCell : UITableViewCell
@property (strong,nonatomic)NSDictionary *titleName;

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
