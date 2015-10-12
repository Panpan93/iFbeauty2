//
//  changePWViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "changePWViewController.h"

@interface changePWViewController ()
- (IBAction)Confirmchange:(UIButton *)sender forEvent:(UIEvent *)event;//修改密码
- (IBAction)fanhui:(UIBarButtonItem *)sender;

@end

@implementation changePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background1"]];

   [Utilities getUserDefaults:@"passWord"];//提取原密码
    
    _oldpassword.clearButtonMode = UITextFieldViewModeAlways;
    _oldpassword.borderStyle = UITextBorderStyleNone;
    _oldpassword.layer.borderColor = [[UIColor whiteColor] CGColor];
    _oldpassword.layer.borderWidth = 2.0f;
    _oldpassword.layer.masksToBounds = YES;
    _oldpassword.layer.cornerRadius = 3;
    _oldpassword.borderStyle = UITextBorderStyleNone;

    
    
    _newpassword.clearButtonMode = UITextFieldViewModeAlways;
    _newpassword.borderStyle = UITextBorderStyleNone;
    _newpassword.layer.borderColor = [[UIColor whiteColor] CGColor];
    _newpassword.layer.borderWidth = 2.0f;
    _newpassword.layer.masksToBounds = YES;
    _newpassword.layer.cornerRadius = 3;
    _newpassword.borderStyle = UITextBorderStyleNone;

    
    _newpassword1.clearButtonMode = UITextFieldViewModeAlways;
    _newpassword1.borderStyle = UITextBorderStyleNone;
    _newpassword1.layer.borderColor = [[UIColor whiteColor] CGColor];
    _newpassword1.layer.borderWidth = 2.0f;
    _newpassword1.layer.masksToBounds = YES;
    _newpassword1.layer.cornerRadius = 3;
    _newpassword1.borderStyle = UITextBorderStyleNone;
    
    
    _saveButton.layer.borderColor = [[UIColor purpleColor] CGColor];
    CALayer *layer = [_saveButton layer];
    layer.cornerRadius = 40;//角的弧度
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框
    
    

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

- (IBAction)Confirmchange:(UIButton *)sender forEvent:(UIEvent *)event {
    PFUser *currentUser = [PFUser currentUser];
    NSString *password = _oldpassword.text;
    NSString *newpassword = _newpassword.text;
    NSString *newpassword2 = _newpassword1.text;
    
    if ([password isEqualToString:[Utilities getUserDefaults:@"passWord"]]) {
        if ([newpassword isEqualToString:newpassword2]) {
            
            currentUser[@"password"] = _newpassword.text;
            UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
            
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)/*如果成功的插入数据库*/ {
                [aiv stopAnimating];
                
                if (succeeded) {
                    //  [Utilities setUserDefaults:@"password" content:_newpasswordTF.text];
                    
                    [Utilities setUserDefaults:@"passWord" content:_newpassword.text];
                    [Utilities popUpAlertViewWithMsg:@"成功修改！" andTitle:nil];
                    
                    [PFUser logOut];//退出Parse
                    [aiv stopAnimating];
                    
                    [PFUser logInWithUsernameInBackground:currentUser.username password:_newpassword.text block:^(PFUser *user, NSError *error) {
                        [aiv stopAnimating];
                        if (user) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else if (error.code == 101) {
                            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
                        } else if (error.code == 100) {
                            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
                        } else {
                            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                            
                        }
                    }];
                } else {
                    [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                }
            }];
            
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"俩次密码不一致，请重新输入" andTitle:nil];
        }
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"与原密码不同，请重新输入" andTitle:nil];
    }
    

}
- (IBAction)fanhui:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];//返回上一级页面
    
}
@end
