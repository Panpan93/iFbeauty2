//
//  readcommentTableViewCell.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "readcommentTableViewCell.h"

@implementation readcommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////给用户介绍赋值并且实现自动换行
//-(void)setIntroductionText:(NSString*)text {
//    
//    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
//    CGSize contentLabelSize = [_commentUserDetail.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_commentUserDetail.font} context:nil].size;
//    NSLog(@"height = %f", contentLabelSize.height);
//    CGRect rect3= [self frame];
//    rect3.size.height = _commentUserDetail.frame.origin.y + contentLabelSize.height + 20;
//    
//    self.frame = rect3;
//
//}
////初始化cell类
//-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier {
//    [super setSelected:selected animated:animated];
//}

@end
