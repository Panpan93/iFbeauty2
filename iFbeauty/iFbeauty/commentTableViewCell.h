//
//  commentTableViewCell.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UILabel *commentname;
@property (weak, nonatomic) IBOutlet UILabel *commentdate;
@property (weak, nonatomic) IBOutlet UILabel *commentdetaiil;


@end
