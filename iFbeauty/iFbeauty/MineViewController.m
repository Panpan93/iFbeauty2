//
//  MineViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/20.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "MineViewController.h"
#import "NewsViewController.h"
#import "ViewController.h"
#import "personalViewController.h"
#import "shoppingViewController.h"
#import "postViewController.h"
#import "changePWViewController.h"
#import "collectionViewController.h"


@interface MineViewController ()
- (IBAction)sender:(UIButton *)sender forEvent:(UIEvent *)event;//帖子
- (IBAction)fans:(UIButton *)sender forEvent:(UIEvent *)event;//粉丝
- (IBAction)focus:(UIButton *)sender forEvent:(UIEvent *)event;//关注
- (IBAction)tapGester:(UITapGestureRecognizer *)sender;
- (IBAction)logIn:(UIBarButtonItem *)sender;
- (IBAction)tuichu:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    hidden=NO;
    _objectforshow=[[NSMutableArray alloc]initWithObjects:@"个人信息",@"时尚芭莎",@"收藏的帖子",@"购物",@"修改密码", nil];
//    _tableIV.delegate=self;
//    _tableIV.dataSource=self;
    _tableIV.tableFooterView=[[UIView alloc]init];//不显示多余的分隔符
    
    CALayer *layer = [_logoutBU layer];
    layer.cornerRadius = 40;//角的弧度
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tupian1.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];


    [self read];
  }

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//视图出现之前做的事情
    [self read];
}

-(void)read
{
    PFUser *currentUser = [PFUser currentUser];
    //        _usernameLB.text=@"";
    //   _imageIV=[UIImage imageNamed:@"background"];
    if (currentUser != nil) {
        _usernameLB.text = currentUser[@"secondname"];
        _account.text=[NSString stringWithFormat:@"账号信息：%@", currentUser[@"username"]];
        
        PFFile *photo = currentUser[@"photo"];
        [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _imageIV.image = image;
                    
                });
            }
        }];
        _loginbutton.enabled=  NO;
        _loginbutton.title=@"已登录";
        _logoutBU.hidden = NO;
    } else {
        _loginbutton.enabled=YES;
        _loginbutton.title=@"登录";
        _logoutBU.hidden = YES;
        _usernameLB.text = @"未登录";
        _imageIV.image = nil;
        //        _usernameLB.text=@"";
    }
}

//    _usernameLB.text = [NSString stringWithFormat:@"%@", currentUser[@"username"]];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.objectforshow.count;
    return [_objectforshow count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=[_objectforshow objectAtIndex:indexPath.row];
    return cell;

}
/*设置cell的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableIV deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row==0) {
        personalViewController *person = [self.storyboard instantiateViewControllerWithIdentifier:@"personal"];
        person.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:person animated:YES];
              }
        if (indexPath.row==1) {
            NewsViewController *news = [[NewsViewController alloc] init];
            news.title = @"时尚芭莎";
            [news setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:news animated:YES];

        }
    if (indexPath.row==2) {
//        collectionViewController *collection = [[collectionViewController alloc] init];
//        collection.title = @"我的收藏";
//        [collection setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:collection animated:YES];
        collectionViewController *collection = [self.storyboard instantiateViewControllerWithIdentifier:@"collec"];
        collection.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collection animated:YES];
        

        
    }

    if (indexPath.row==3) {
        shoppingViewController *shop = [[shoppingViewController alloc] init];
        shop.title = @"京东商城";
        [shop setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:shop animated:YES];
    }
    if (indexPath.row==4) {
//        changePWViewController *change = [[changePWViewController alloc] init];
//        change.title = @"修改密码";
//        [change setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:change animated:YES];
//        changePWViewController *change = [self.storyboard instantiateViewControllerWithIdentifier:@"change"];
//        
//        //初始化导航控制器
//        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:change];
//        //动画效果
//        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        //导航条隐藏掉
//        nc.navigationBarHidden = YES;
//        //类似那个箭头 跳转到第二个界面
//        [self presentViewController:nc animated:YES completion:nil];
        changePWViewController *change = [self.storyboard instantiateViewControllerWithIdentifier:@"change"];
        change.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:change animated:YES];


    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma   读自己发的帖子
- (IBAction)sender:(UIButton *)sender forEvent:(UIEvent *)event {
    
        postViewController *post = [self.storyboard instantiateViewControllerWithIdentifier:@"post"];
        post.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:post animated:YES];
        

    
}
- (IBAction)focus:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)fans:(UIButton *)sender forEvent:(UIEvent *)event {
}
#pragma   修改图片

- (IBAction)tapGester:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    }
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2)
        return;
    
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _imageIV.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    //    上传图片
    PFUser *currentUser = [PFUser currentUser];
    NSData *photoData = UIImagePNGRepresentation(_imageIV.image);
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    currentUser[@"photo"] = photoFile;
    
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

#pragma   登录

- (IBAction)logIn:(UIBarButtonItem *)sender {
      ViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"denglu"];
    if (!hidden) {
        //初始化导航控制器
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:denglu];
    //动画效果
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //导航条隐藏掉
    nc.navigationBarHidden = NO;
    //类似那个箭头 跳转到第二个界面
    [self presentViewController:nc animated:YES completion:nil];
          _buttonItem.enabled=YES;
    
    }
    
//    ViewController *meif = [self.storyboard instantiateViewControllerWithIdentifier:@"denglu"];
//    meif.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:meif animated:YES];

}
#pragma   退出
- (IBAction)tuichu:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [PFUser logOut];//Parse 退出
//     [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页
    
    [self read];

}


@end
