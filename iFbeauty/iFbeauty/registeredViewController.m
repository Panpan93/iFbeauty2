//
//  registeredViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "registeredViewController.h"

@interface registeredViewController ()
- (IBAction)registeredBN:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation registeredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *layer = [_zhuceButton layer];
    layer.cornerRadius = 35;//角的弧度
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registeredBN:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PFUser *currentUser = [PFUser currentUser];

    NSString *username = _usernameTF.text;
    NSString *email = _emealTF.text;
    NSString *password = _passwordTF.text;
    NSString *confirmPwd = _password1TF.text;
    
    if ([username isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""] || [confirmPwd isEqualToString:@""] ) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    
    if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"确认密码必须与密码保持一致" andTitle:nil];
    }
    //创建用户
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //把创建的用户插入数据库
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];//菊花停止转动
        if (!error) {
            [[storageMgr singletonStorageMgr] addKeyAndValue:@"signUp" And:@1];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if (error.code == 202) {
            [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
        } else if (error.code == 203) {
            [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
        } else if (error.code == 125) {
            [Utilities popUpAlertViewWithMsg:@"该邮箱地址为非法地址" andTitle:nil];
        }else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    

}
@end
