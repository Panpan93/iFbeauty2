//
//  firstViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "firstViewController.h"
#import "ViewController.h"

@interface firstViewController ()
- (IBAction)logIn:(UIBarButtonItem *)sender;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logIn:(UIBarButtonItem *)sender {
    ViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"denglu"];
    
    //初始化导航控制器
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:denglu];
    //动画效果
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //导航条隐藏掉
    nc.navigationBarHidden = NO;
    //类似那个箭头 跳转到第二个界面
    [self presentViewController:nc animated:YES completion:nil];
    
}
@end
