//
//  ViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
//<UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>//外观


@property (weak, nonatomic) IBOutlet UITextField *usernameTF;//账号
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;//图片
//下面两个测划界面时用到
//@property(strong,nonatomic)ECSlidingViewController *slidingViewController;
//@property(assign,nonatomic)ECSlidingViewControllerOperation operation;
@end

