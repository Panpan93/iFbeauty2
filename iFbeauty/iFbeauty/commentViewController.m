//
//  commentViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "commentViewController.h"
#import "commentTableViewCell.h"

@interface commentViewController ()

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self uiConfiguration];
     _tableView.tableFooterView=[[UIView alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
    
    _titlelabel.text = _commentItem[@"title"];
    _deLabel.text =[NSString stringWithFormat:@"%@", _commentItem[@"detail"]];

    
    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_deLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_deLabel.font} context:nil].size;
    NSLog(@"height = %f", contentLabelSize.height);
   
        CGRect rect = _header.frame;
        rect.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 20;
        _header.frame = rect;
        _tableView.tableHeaderView = _header;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem == %@",_commentobject];
    NSLog(@"_commentobject == %@",_commentobject);
    PFQuery *query = [PFQuery queryWithClassName:@"comment" predicate:predicate];
    
    [query includeKey:@"commentUser"];//关联查询
    [query includeKey:@"commentItem"];//关联查询
    [SVProgressHUD show];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
  //  _objectsForShow = _commentobject;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _objectsForShow.count;;
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
   // PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.commentdetaiil.text = [NSString stringWithFormat:@"%@", _commentobject[@"commentdetail"]];
    
    NSLog(@"commentdetaiil == %@",cell.commentdetaiil.text);
    
    PFObject *activity = _commentobject[@"commentUser"];
    
    cell.commentname.text =[NSString stringWithFormat:@" %@   评论", activity[@"secondname"]];

    NSLog(@"%@",activity);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.userimage.image = image;
            });
        }
    }];
    
    
    //显示发帖时间
    NSDate *createdAt = _commentobject.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    cell.commentdate.text = [NSString stringWithFormat:@"%@",strDate];
    
    
    return cell;
    
}







- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 1) {
        [self shanchu];
        NSLog(@"YES");
    } else {
        NSLog(@"no");
    }
}

- (void) shanchu {
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@",_commentobject];
//    PFQuery *query2 = [PFQuery queryWithClassName:@"comment" predicate:predicate];
//    
//    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            for (PFObject *comm in objects) {
//                [comm deleteInBackground];
//            }
//        }
//    }];
    
    [_commentobject deleteInBackground];
    
    
    [SVProgressHUD show];
    //判断上传成功
    [_commentobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)/**/ {
        [SVProgressHUD dismiss];
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];//通过通知去刷新列表。自动刷新，
            [self.navigationController popViewControllerAnimated:YES];//刷新页面
            NSLog(@"1");
            
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    
    
}


- (IBAction)deleteButtenItem:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您要删除这条评论吗？" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*下拉刷新*/
-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor brownColor];
    //背景色 浅灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //执行的动作
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    
    [_tableView reloadData];
    
    
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    
    [_tableView reloadData];
    //怎么样让方法延迟执行的
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
}
//闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

