//
//  ViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "ViewController.h"
#import "TabViewController.h"

#import "MineViewController.h"
@interface ViewController ()
- (IBAction)forgot:(UIButton *)sender forEvent:(UIEvent *)event;//忘记密码
- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event;//登录
- (IBAction)registered:(UIButton *)sender forEvent:(UIEvent *)event;//注册
- (IBAction)backAction:(UIBarButtonItem *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];

    
    [self uiView];
    if (![[Utilities getUserDefaults:@"uName"] isKindOfClass:[NSNull class]]) {
        _usernameTF.text = [Utilities getUserDefaults:@"uName"];
        
    }
    PFUser *currentUser = [PFUser currentUser];

    PFFile *photo = currentUser[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoIV.image = image;
                
            });
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
//点击空白处键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
//输入框设置
-(void)uiView
{
    _usernameTF.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.layer.borderColor = [[UIColor clearColor] CGColor];
    _passwordTF.layer.borderWidth = 2.0f;
    _passwordTF.layer.masksToBounds = YES;
    _passwordTF.layer.cornerRadius = 3;
    _usernameTF.borderStyle = UITextBorderStyleNone;
    _usernameTF.layer.borderColor = [[UIColor clearColor] CGColor];
    _usernameTF.layer.borderWidth = 2.0f;
    _usernameTF.layer.masksToBounds = YES;
    _usernameTF.layer.cornerRadius = 3;
    
  //  _passwordTF.layer.borderColor = [[UIColor whiteColor] CGColor];
    CALayer *layer = [_dengluButton layer];
    layer.cornerRadius = 35;//角的弧度
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框
    
   
}
#pragma mark   页面跳转方法
- (void)popUpHomePage
{
//    TabViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"];
//    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];//创建一个导航控制器
//    naviVC.navigationBarHidden = YES;
////    _navigationItem.hidesBackButton=YES;
//    [self presentViewController:naviVC animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页
}
- (IBAction)forgot:(UIButton *)sender forEvent:(UIEvent *)event {
        [PFUser requestPasswordResetForEmailInBackground:@"emaile"];
}

- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    
//    FDActivityIndicatorView *div = [Utilities getCoverOnView:self.view];
//    [div addAnimation];
     //UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [SVProgressHUD show];

    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
      //   [aiv stopAnimating];
        [SVProgressHUD dismiss];

        if (user) {
            [Utilities setUserDefaults:@"userName" content:username];//记住用户名
            [Utilities setUserDefaults:@"passWord" content:password];
            //            _password1.text = @"";//用户退出后，首页的textfield为空
            [self popUpHomePage];
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    
}

- (IBAction)registered:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
