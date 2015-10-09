//
//  guanzhuTableViewCell.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/8.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guanzhuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *focusImage;
@property (weak, nonatomic) IBOutlet UILabel *focusName;

@property (weak, nonatomic) IBOutlet UILabel *focusXinxi;
@end
