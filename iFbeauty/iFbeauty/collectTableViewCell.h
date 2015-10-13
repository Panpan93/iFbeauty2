//
//  collectTableViewCell.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/8.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentUserDetail;
@property (weak, nonatomic) IBOutlet UILabel *commentUserDate;

@end
