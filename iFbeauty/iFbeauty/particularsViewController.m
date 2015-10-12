//
//  particularsViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "particularsViewController.h"
#import "hairdressingTableViewCell.h"
#import "readcommentTableViewCell.h"
#import "ViewController.h"

@interface particularsViewController ()


- (IBAction)praiseAction:(UIBarButtonItem *)sender;
- (IBAction)collectAction:(UIBarButtonItem *)sender;
- (IBAction)commentAction:(UIBarButtonItem *)sender;
- (IBAction)ConcernAction:(UIButton *)sender forEvent:(UIEvent *)event;



@end

@implementation particularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self praiseData];
    [self collectData];
    [self focusData];
    [self quxiaoData];
     _tableView.tableFooterView=[[UIView alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];


    PFFile *userphoto = _item[@"photot"];
    
    _userName.text =[NSString stringWithFormat:@"发帖人： %@", _ownername[@"secondname"]];
    NSLog(@"用户名%@",_userName.text);

    
    _userTitle.text = _item[@"title"];
    _deLabel.text =[NSString stringWithFormat:@"%@", _item[@"detail"]];
    PFFile *photo = _ownername[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _userImage.image = image;
            });
        }
    }];
    
    NSDate *createdAt = _item.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    _userDate.text = [NSString stringWithFormat:@"%@",strDate];

    
    


    
//    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_deLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_deLabel.font} context:nil].size;
//    NSLog(@"height = %f", contentLabelSize.height);
    if (userphoto == nil) {
        _userImage.image = nil;
        CGRect rect = _header.frame;
        rect.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 20;
        _header.frame = rect;
        _tableView.tableHeaderView.frame = rect;
        _particularsIV.hidden = YES;
        _lineView.hidden = YES;
        _lineView2.hidden = NO;
    } else {
        CGRect rect2 = _header.frame;
        rect2.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 450;
        _header.frame = rect2;
        _tableView.tableHeaderView.frame = rect2;
        [userphoto getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _particularsIV.image = image;
                });
            }
        }];
        _particularsIV.hidden = NO;
        _lineView.hidden = NO;
        _lineView2.hidden = YES;
    }
    
    _tableView.tableFooterView=[[UIView alloc]init];//不显示多余的分隔符
    
    
    

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



//点击赞
- (IBAction)praiseAction:(UIBarButtonItem *)sender {
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"您还没有登录，请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert2.alertViewStyle = UIAlertViewStyleDefault;
        [alert2 show];
        alert2.tag = 200;
        return;
        
    }
    
    if ([_zanItem.title isEqualToString:@"赞"]) {
        PFUser *current=[PFUser currentUser];

        PFObject *praise = [PFObject objectWithClassName:@"praise"];
        
        praise[@"praiseitem"] = _item;
        praise[@"praiseuser"] = current;
        praise[@"zan"]=@"赞";
        [praise saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
                [self praiseData];
            }
            else{
                NSLog(@"error=%@",error);
            }
            
        }];
      
    }
    [_item incrementKey:@"praise"];
    
    [_item saveInBackground];
    

    
}
-(void)praiseData
{
    PFUser *current=[PFUser currentUser];

    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"praiseitem == %@ AND praiseuser == %@", _item, current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"praise" predicate:predicate3];
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
         
            if (number == 0) {
                _zanItem.title=@"赞";
                _zanItem.enabled=YES;
                
            } else {
                _zanItem.title=@"已赞";
                _zanItem.enabled=NO;
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
  }

//点击收藏
- (IBAction)collectAction:(UIBarButtonItem *)sender {
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"您还没有登录，请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert2.alertViewStyle = UIAlertViewStyleDefault;
        [alert2 show];
        alert2.tag = 200;
        return;
        
    }

    if ([_shoucangItem.title isEqualToString:@"收藏"]) {
        PFUser *current=[PFUser currentUser];

        PFObject *praise = [PFObject objectWithClassName:@"collection"];
        
        praise[@"shoucangitem"] = _item;
        praise[@"shoucanguser"] = current;
        praise[@"shoucang"]=@"收藏";
        [praise saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
                [self collectData];
            }
            else{
                NSLog(@"error=%@",error);
            }
            
        }];
        NSLog(@" 收藏==  %@",praise[@"shoucang"]);
    }

    
}
-(void)collectData
{
    
    //PFObject *praise = [PFObject objectWithClassName:@"praise"];
    PFUser *current=[PFUser currentUser];

    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"shoucangitem == %@ AND shoucanguser == %@",_item,current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"collection" predicate:predicate3];
    
    //   PFObject *object = [PFObject objectWithClassName:@"praise" dictionary:predicate3];
    
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == 0) {
                _shoucangItem.title=@"收藏";
                _shoucangItem.enabled=YES;
                
            } else {
                _shoucangItem.title=@"已收藏";
                _shoucangItem.enabled=NO;
            }
        }
    }];
    
}
//点击评论
- (IBAction)commentAction:(UIBarButtonItem *)sender {
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        //  [Utilities popUpAlertViewWithMsg:@"您还没有登录，请登录" andTitle:nil];
        
        // return;
        
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"您还没有登录，请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert2.alertViewStyle = UIAlertViewStyleDefault;
        [alert2 show];
        alert2.tag = 200;
        return;
        
        
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请发表您的评论" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    alert.tag = 100;

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (alertView.tag == 200) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        
        if ([buttonTitle isEqualToString:@"登录"]) {
            
            ViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"denglu"];
            //初始化导航控制器
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:denglu];
            //动画效果
            nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //导航条隐藏掉
            nc.navigationBarHidden = NO;
            //类似那个箭头 跳转到第二个界面
            [self presentViewController:nc animated:YES completion:nil];
            
            
            
            
        }
        
    }
    
    
    
    if (alertView.tag == 100) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"确定"]){
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *formatter = textField.text;
            
            PFUser *user = [PFUser currentUser];
            //创建一个item
            PFObject *item = [PFObject objectWithClassName:@"comment"];
            item[@"commentdetail"] = formatter;
            
            item[@"commentItem"] = _item;
            item[@"commentUser"] = user;
            if ([textField.text isEqualToString:@""]) {
                [Utilities popUpAlertViewWithMsg:@"请填写全部信息" andTitle:nil];
                return;//终止该方法，下面的代码不会被执行
            }
            
            [self performSelector:@selector(delayHappen:) withObject:item afterDelay:0.5];
        }
        
    }
    
}

//点击添加关注

- (IBAction)ConcernAction:(UIButton *)sender forEvent:(UIEvent *)event {

    if ([_Concern.titleLabel.text isEqualToString:@"我要关注"]) {
        PFUser *current=[PFUser currentUser];
        PFObject *focus = [PFObject objectWithClassName:@"Concern"];
        //关注的人
        focus[@"focus"] = _ownername;
        //当前登陆的用户
        focus[@"focusecond"] = current;
        
        [focus saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
                [self focusData];
            }
            else{
                NSLog(@"error=%@",error);
            }
        }];
    } else {
        if ([_Concern.titleLabel.text isEqualToString:@"取消关注"])
        {
           
            [self quxiaoData];
        }
        
    }
}
-(void)quxiaoData
{
    PFUser *current=[PFUser currentUser];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_ownername, current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
    NSLog(@" query3  == %@ ",query3);
    
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (!number == 0) {
                PFUser *current=[PFUser currentUser];
                
                NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_ownername, current];
                
                PFQuery *query4 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
                
                [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *quxiao in objects) {
                            [quxiao deleteInBackground];
                        }
                    }
                }];
                
                [_ownername deleteInBackground];
                

                
            }
        }
        else{
            NSLog(@"error=%@",error);
        }
        
    }];
    
    

}

-(void)focusData
{
    PFUser *current=[PFUser currentUser];

    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_ownername, current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
    NSLog(@" query3  == %@ ",query3);
    
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == 0) {
                
                _Concern.titleLabel.text=@"我要关注";
                
              
                
            } else {
                
                _Concern.titleLabel.text=@"取消关注";
                
            }
        }
        else{
            NSLog(@"error=%@",error);
        }

    }];
    
    
}


- (void)delayHappen:(PFObject *)item {
    [SVProgressHUD show];
    //判断上传成功
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)/*如果成功的插入数据库*/ {
        if (succeeded) {
            [self requestData];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            [SVProgressHUD dismiss];
        }
    }];
}


- (void)requestData {
    
    //PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem == %@",_item];
    PFQuery *query2 = [PFQuery queryWithClassName:@"comment" predicate:predicate];
    
    [query2 includeKey:@"commentUser"];//关联查询
    [query2 includeKey:@"commentItem"];//关联查询
    [SVProgressHUD show];

    [query2 findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];

        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    //赞的数量
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"praiseitem == %@", _item];
    PFQuery *query3 = [PFQuery queryWithClassName:@"praise" predicate:predicate3];
    [query3 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            NSString* s = [NSString stringWithFormat:@"%d", count];
            _zanLabel.text = s;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //评论的数量
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"commentItem == %@", _item];
    PFQuery *query4 = [PFQuery queryWithClassName:@"comment" predicate:predicate4];
    [query4 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            NSString* s = [NSString stringWithFormat:@"%d", count];
            _pinglunLabel.text = s;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

/****根据评论的内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    readcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [object[@"commentdetail"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    NSLog(@"origin = %f", cell.commentUserDetail.frame.origin.y);
    NSLog(@"height = %f", contentLabelSize.height);
    NSLog(@"totalHeight = %f", cell.commentUserDetail.frame.origin.y + contentLabelSize.height + 20);
    return cell.commentUserDetail.frame.origin.y + contentLabelSize.height + 21;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    readcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.commentUserDetail.text = [NSString stringWithFormat:@"%@", object[@"commentdetail"]];
    
    PFObject *activity = object[@"commentUser"];
    
    cell.commentUserName.text =[NSString stringWithFormat:@" %@  ", activity[@"secondname"]];
    NSLog(@"%@",activity);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.commentUserImage.image = image;
            });
        }
    }];
    
    //显示发帖时间
    NSDate *createdAt = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    cell.commentUserDate.text = [NSString stringWithFormat:@"%@",strDate];

    
    return cell;
    
}

@end
