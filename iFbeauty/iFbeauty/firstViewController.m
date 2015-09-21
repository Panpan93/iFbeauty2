//
//  firstViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "firstViewController.h"
#import "ViewController.h"
#import "SendpostViewController.h"

@interface firstViewController ()

- (IBAction)send:(UIBarButtonItem *)sender;

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



- (IBAction)send:(UIBarButtonItem *)sender {
    
    SendpostViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:denglu];
       //动画效果
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //导航条隐藏掉
    nc.navigationBarHidden = YES;
        //类似那个箭头 跳转到第二个界面
    [self presentViewController:nc animated:YES completion:nil];

}
@end
