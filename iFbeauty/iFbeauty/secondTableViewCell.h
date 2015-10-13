//
//  secondTableViewCell.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface secondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *pinglun;
@property (weak, nonatomic) IBOutlet UILabel *tiezi;
@property (weak, nonatomic) IBOutlet UILabel *commentdate;

@end
