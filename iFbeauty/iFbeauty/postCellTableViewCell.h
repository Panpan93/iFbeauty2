//
//  postCellTableViewCell.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postLabel;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (IBAction)postAction:(id)sender;
@end
