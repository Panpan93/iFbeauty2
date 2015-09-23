//
//  personalTableViewCell.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/22.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "personalTableViewCell.h"

@implementation personalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self textfile];
}

-(void)textfile
{
    _editor.textColor=[UIColor blackColor];
    _editor.clearButtonMode=UITextFieldViewModeAlways;
    _editor.clearsOnBeginEditing=YES;
    _editor.adjustsFontSizeToFitWidth=YES;
    _editor.backgroundColor=[UIColor clearColor];
    _editor.borderStyle=UITextBorderStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_editable) {
        NSLog(@"YES");
        _editor.enabled = YES;
    } else {
        NSLog(@"NO");
        _editor.enabled = NO;
    }
}

@end
