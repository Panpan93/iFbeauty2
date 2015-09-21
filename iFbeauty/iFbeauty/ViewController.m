//
//  ViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "ViewController.h"
#import "TabViewController.h"
#import "cehuaViewController.h"
@interface ViewController ()
- (IBAction)forgot:(UIButton *)sender forEvent:(UIEvent *)event;//忘记密码
- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event;//登录
- (IBAction)registered:(UIButton *)sender forEvent:(UIEvent *)event;//注册
- (IBAction)backAction:(UIBarButtonItem *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _passwordTF.layer.borderColor = [[UIColor redColor] CGColor];
    _passwordTF.layer.borderWidth = 2.0f;
    _passwordTF.layer.masksToBounds = YES;
    _passwordTF.layer.cornerRadius = 3;
    _usernameTF.borderStyle = UITextBorderStyleNone;
    _usernameTF.layer.borderColor = [[UIColor purpleColor] CGColor];
    _usernameTF.layer.borderWidth = 2.0f;
    _usernameTF.layer.masksToBounds = YES;
    _usernameTF.layer.cornerRadius = 3;
    
    _passwordTF.layer.borderColor = [[UIColor purpleColor] CGColor];
    
   
}
#pragma mark   页面跳转方法
- (void)popUpHomePage
{
    TabViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];//创建一个导航控制器
    naviVC.navigationBarHidden = YES;
    _slidingViewController=[ECSlidingViewController slidingWithTopViewController:naviVC];//初始化并设置popview（中间页面）
    _slidingViewController.delegate=self;//初始化
    
    
    //    _slidingViewController.defaultTransitionDuration = 0.25;//    滑动动画默认时间
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;//触摸和拖动
    [naviVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    cehuaViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"left"];
    _slidingViewController.underLeftViewController = leftVC;//设置作画试图
    _slidingViewController.anchorRightPeekAmount = UI_SCREEN_W / 4;//划到什么位置anchorRightPeekAmount当画出左侧菜单式中间页面左边到屏幕右边的距离anchorleftPeekAmount当画出右侧页面时中间页面右边到屏幕左边的距离
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction) name:@"leftSwitch" object:nil];//通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePanGesOnSliding) name:@"enablePanGes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablePanGesOnSliding) name:@"disablePanGes" object:nil];
    //     [self presentViewController:naviVC animated:YES completion:nil];//Model过去
    [self presentViewController:_slidingViewController animated:YES completion:nil];//Model过去
}

- (void)leftSwitchAction {
    if (_slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [_slidingViewController resetTopViewAnimated:YES];
    } else {
        [_slidingViewController anchorTopViewToRightAnimated:YES];
    }
}
- (void)enablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = YES;
}//手势激活

- (void)disablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = NO;
}//手势关闭

#pragma mark - ECSlidingViewControllerDelegate和其他两个协议关联

- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController animationControllerForOperation:(ECSlidingViewControllerOperation)operation topViewController:(UIViewController *)topViewController {//当你做某个操作时返回一些动画效果
    _operation = operation;
    return self;
}

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {//
    return self;
}
#pragma mark - ECSlidingViewControllerLayout

- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController frameForViewController:(UIViewController *)viewController topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight && viewController == slidingViewController.topViewController) {
        return [self topViewAnchoredRightFrame:slidingViewController];
    } else {
        return CGRectInfinite;
    }
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;//动画时间
}
//页与页动画转换
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *underLeftViewController  = [transitionContext viewControllerForKey:ECTransitionContextUnderLeftControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *topView = topViewController.view;
    topView.frame = containerView.bounds;
    underLeftViewController.view.layer.transform = CATransform3DIdentity;
    
    if (_operation == ECSlidingViewControllerOperationAnchorRight) {
        [containerView insertSubview:underLeftViewController.view belowSubview:topView];
        
        [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewEndState:underLeftViewController.view];
            [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext finalFrameForViewController:topViewController]];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                underLeftViewController.view.frame = [transitionContext finalFrameForViewController:underLeftViewController];
                underLeftViewController.view.alpha = 1;
                [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
            }
            [transitionContext completeTransition:finished];
        }];
    } else if (_operation == ECSlidingViewControllerOperationResetFromRight) {
        [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
        [self underLeftViewEndState:underLeftViewController.view];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self underLeftViewEndState:underLeftViewController.view];
                [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
            } else {
                underLeftViewController.view.alpha = 1;
                underLeftViewController.view.layer.transform = CATransform3DIdentity;
                [underLeftViewController.view removeFromSuperview];
            }
            [transitionContext completeTransition:finished];
        }];
    }
}


#pragma mark - Private私有方法

- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController {
    CGRect frame = slidingViewController.view.bounds;
    
    frame.origin.x = slidingViewController.anchorRightRevealAmount;
    frame.size.width = frame.size.width * 0.75;
    frame.size.height = frame.size.height * 0.75;
    frame.origin.y = (slidingViewController.view.bounds.size.height - frame.size.height) / 2;
    
    return frame;
}
- (void)topViewStartingStateLeft:(UIView *)topView containerFrame:(CGRect)containerFrame {
    topView.layer.transform = CATransform3DIdentity;
    topView.layer.position = CGPointMake(containerFrame.size.width / 2, containerFrame.size.height / 2);
}

- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame {
    underLeftView.alpha = 0;
    underLeftView.frame = containerFrame;
    underLeftView.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
}

- (void)underLeftViewEndState:(UIView *)underLeftView {
    underLeftView.alpha = 1;
    underLeftView.layer.transform = CATransform3DIdentity;
}

- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame {
    topView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
    topView.frame = anchoredFrame;
    topView.layer.position  = CGPointMake(anchoredFrame.origin.x + ((topView.layer.bounds.size.width * 0.75) / 2), topView.layer.position.y);
}

- (IBAction)forgot:(UIButton *)sender forEvent:(UIEvent *)event {
        [PFUser requestPasswordResetForEmailInBackground:@"emaile"];
}

- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event {
//    //动画效果
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.0;//持续时间
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;//缓慢的开始和结束
//    
//    animation.type = @"rippleEffect";//产生波纹效果
//    animation.subtype = kCATransitionFromLeft;//图标类型从左过度
//    [self.view.window.layer addAnimation:animation forKey:nil];
//
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
