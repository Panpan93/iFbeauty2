//
//  cehuaViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "cehuaViewController.h"
#import "changePWViewController.h"

@interface cehuaViewController ()

//修改图片
- (IBAction)modifyUser:(UIButton *)sender forEvent:(UIEvent *)event;//修改用户名
- (IBAction)modifyPassword:(UIButton *)sender forEvent:(UIEvent *)event;//修改密码
- (IBAction)setUp:(UIButton *)sender forEvent:(UIEvent *)event;//设置
- (IBAction)exit:(UIButton *)sender forEvent:(UIEvent *)event;//退出
- (IBAction)pickAction:(UITapGestureRecognizer *)sender;


@end

@implementation cehuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self photo];
    CALayer *layer = [_photoBN layer];
    layer.cornerRadius = 40;//角的弧度
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框

    
    PFUser *currentUser = [PFUser currentUser];
    _nameLabel.text = currentUser[@"username"];
    
    PFFile *photo = currentUser[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoBN.image = image;

            });
        }
    }];

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

- (IBAction)modifyUser:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改用户名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //背景View
    //    UIView *additonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alert.frame.size.width-30, alert.frame.size.height-20)];
    //    additonBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Image"]]; //添加背景图片
    //    [alert insertSubview:additonBackgroundView atIndex:1];
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    PFUser *currentUser = [PFUser currentUser];
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if ([textField.text isEqualToString:@""]) {
                [Utilities popUpAlertViewWithMsg:@"请填写名字" andTitle:nil];
                return;//终止该方法，下面的代码不会被执行
            }
            
            if ([textField.text isEqualToString:_nameLabel.text]) {
                [Utilities popUpAlertViewWithMsg:@"输入的名字相同，请重新输入" andTitle:nil];
            }
            
            //读用户输入的内容
            NSString *formatter = textField.text;
            //上传用户输入的内容
            currentUser[@"username"] = formatter;
            //读取内容
            _nameLabel.text = [NSString stringWithFormat:@"%@", currentUser[@"username"]];
            
            NSString *na = _nameLabel.text;
            [Utilities setUserDefaults:@"uName" content:na];
            
            //刷新
            UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [aiv stopAnimating];
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                }
            }];
            
        }

}

- (IBAction)modifyPassword:(UIButton *)sender forEvent:(UIEvent *)event {
    changePWViewController *change = [self.storyboard instantiateViewControllerWithIdentifier:@"change"];
    
    //初始化导航控制器
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:change];
    //动画效果
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //导航条隐藏掉
    nc.navigationBarHidden = YES;
    //类似那个箭头 跳转到第二个界面
    [self presentViewController:nc animated:YES completion:nil];
    

    
}

- (IBAction)setUp:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)exit:(UIButton *)sender forEvent:(UIEvent *)event {
       [PFUser logOut];//parse退出
    [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页

}
- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];

    
}
@end


