//
//  deleteViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "deleteViewController.h"
#import "deleteTableViewCell.h"

@interface deleteViewController ()

@end

@implementation deleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)deleteButtenItem:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的帖子将彻底删除，您确定要删除吗？" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
