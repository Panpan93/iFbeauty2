//
//  secondViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "secondViewController.h"
#import "SendViewController.h"

@interface secondViewController ()
- (IBAction)send:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation secondViewController

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
//- (void)fuJinFriends{
//    
//    SendViewController *send = [[SendViewController alloc] init];
//    send.title =@"发帖";
//    [self.navigationController pushViewController:send animated:YES];
//    NSLog(@"进入附近好友界面");
//}

- (IBAction)send:(UIButton *)sender forEvent:(UIEvent *)event {
    
    SendViewController *send = [[SendViewController alloc] init];
    send.title =@"发帖";
    [self.navigationController pushViewController:send animated:YES];
    NSLog(@"进入发帖界面");
    

}
@end
