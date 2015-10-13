//
//  postDetailViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/10.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "postDetailViewController.h"
#import "postDetailTableViewCell.h"

@interface postDetailViewController ()
- (IBAction)zanAction:(UIBarButtonItem *)sender;
- (IBAction)shoucangAction:(UIBarButtonItem *)sender;

- (IBAction)commentAction:(UIBarButtonItem *)sender;

@end

@implementation postDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self praiseData];
    [self collectData];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
    
    _name1.text =[NSString stringWithFormat:@"发帖人： %@", _xinxi[@"secondname"]];
    NSLog(@"用户名%@",_name1.text);
    
    
    _postTitle.text = _item[@"title"];
    _postdetail.text =[NSString stringWithFormat:@"%@", _item[@"detail"]];
    PFFile *photo = _xinxi[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _image1.image = image;
            });
        }
    }];
    
    NSDate *createdAt = _item.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    _shijian1.text = [NSString stringWithFormat:@"%@",strDate];
    
    
    //赞的数量
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"praiseitem == %@", _item];
    PFQuery *query3 = [PFQuery queryWithClassName:@"praise" predicate:predicate3];
    [query3 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            NSString* s = [NSString stringWithFormat:@"%d", count];
            _zan.text = s;
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
            _comment.text = s;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    PFFile *postphoto = _item[@"photot"];

    
    //    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_postdetail.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_postdetail.font} context:nil].size;
    //    NSLog(@"height = %f", contentLabelSize.height);
    if (postphoto == nil) {
        CGRect rect = _header.frame;
        rect.size.height = _postdetail.frame.origin.y + contentLabelSize.height + 20;
        _header.frame = rect;
        _tableview.tableHeaderView.frame = rect;
        _postImage.hidden = YES;
        _lineView.hidden = YES;
        _lineView2.hidden = NO;
    } else {
        CGRect rect2 = _header.frame;
        rect2.size.height = _postdetail.frame.origin.y + contentLabelSize.height + 450;
        _header.frame = rect2;
        _tableview.tableHeaderView.frame = rect2;
        [postphoto getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _postImage.image = image;
                });
            }
        }];
        _postImage.hidden = NO;
        _lineView.hidden = NO;
        _lineView2.hidden = YES;
    }
    
    _tableview.tableFooterView=[[UIView alloc]init];//不显示多余的分隔符
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
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
            _objectArray = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectArray);
            [_tableview reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/****根据评论的内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    postDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postdetailcell"];
    
    PFObject *object = [_objectArray objectAtIndex:indexPath.row];
    
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [object[@"commentdetail"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    NSLog(@"origin = %f", cell.commentText.frame.origin.y);
    NSLog(@"height = %f", contentLabelSize.height);
    NSLog(@"totalHeight = %f", cell.commentText.frame.origin.y + contentLabelSize.height + 20);
    return cell.commentText.frame.origin.y + contentLabelSize.height + 21;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    postDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postdetailcell" forIndexPath:indexPath];
    
    
    PFObject *object = [_objectArray objectAtIndex:indexPath.row];
    cell.commentText.text = [NSString stringWithFormat:@"%@", object[@"commentdetail"]];
    
    PFObject *activity = object[@"commentUser"];
    
    cell.name2.text =[NSString stringWithFormat:@" %@  ", activity[@"secondname"]];
    NSLog(@"%@",activity);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image2.image = image;
            });
        }
    }];
    
    //显示发帖时间
    NSDate *createdAt = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    cell.shijian3.text = [NSString stringWithFormat:@"%@",strDate];
    
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//点击实现赞
- (IBAction)zanAction:(UIBarButtonItem *)sender {
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

//点击进行收藏
- (IBAction)shoucangAction:(UIBarButtonItem *)sender {
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
//进行评论
- (IBAction)commentAction:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请发表您的评论" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];

}

@end
