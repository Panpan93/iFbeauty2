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

@interface particularsViewController ()


- (IBAction)praiseAction:(UIBarButtonItem *)sender;
- (IBAction)collectAction:(UIBarButtonItem *)sender;
- (IBAction)commentAction:(UIBarButtonItem *)sender;



@end

@implementation particularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];

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
    
    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_deLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_deLabel.font} context:nil].size;
    NSLog(@"height = %f", contentLabelSize.height);
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



//点击评论
- (IBAction)commentAction:(UIButton *)sender forEvent:(UIEvent *)event {
}


//点击赞
- (IBAction)praiseAction:(UIBarButtonItem *)sender {
    [self praiseData];
    
}
-(void)praiseData
{
    
    [_item incrementKey:@"praise"];
    
    [_item saveInBackground];
    
}

//点击收藏
- (IBAction)collectAction:(UIBarButtonItem *)sender {
}

- (IBAction)commentAction:(UIBarButtonItem *)sender { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请发表您的评论" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]){
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *formatter = textField.text;
        
        
        
        //创建一个item
        PFObject *item = [PFObject objectWithClassName:@"comment"];
        item[@"commentdetail"] = formatter;
        
        item[@"commentItem"] = _item;
        item[@"commentUser"] = _ownername;
        
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
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableView reloadData];
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
    
    return cell;
    
}

@end
