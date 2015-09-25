//
//  readcommentTableViewCell.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface readcommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentUserImage;
@property (weak, nonatomic) IBOutlet UILabel *commentUserName;
@property (weak, nonatomic) IBOutlet UILabel *commentUserDate;
@property (weak, nonatomic) IBOutlet UILabel *commentUserDetail;


//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
