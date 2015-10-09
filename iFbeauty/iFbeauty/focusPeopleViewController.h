//
//  focusPeopleViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface focusPeopleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nicheng;
@property (weak, nonatomic) IBOutlet UILabel *xingbie;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *guanzhu;
@property (weak, nonatomic) IBOutlet UILabel *zhanghao;
@property (weak, nonatomic) IBOutlet UILabel *qianming;

@property (weak, nonatomic) IBOutlet UILabel *dizhi;

@property (weak, nonatomic) IBOutlet UILabel *youxiang;
@property (strong, nonatomic) PFObject *chuanru;

@end
