//
//  deleteViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "deleteViewController.h"
#import "deleteTableViewCell.h"

@interface deleteViewController ()

@end

@implementation deleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];  // Do any additional setup after loading the view.
    [self requestData];
    [self uiConfiguration];
    
    _header.clipsToBounds = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];

    
    //赞的数量
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"praiseitem == %@", _item];
    PFQuery *query3 = [PFQuery queryWithClassName:@"praise" predicate:predicate3];
    [query3 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            NSString* s = [NSString stringWithFormat:@"%d", count];
            _like.text = s;
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
            _commen.text = s;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFFile *photoimage = _item[@"photot"];
    
    _titlelabel.text = _item[@"title"];
    _deLabel.text =[NSString stringWithFormat:@"%@", _item[@"detail"]];
    
    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_deLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_deLabel.font} context:nil].size;
    NSLog(@"height = %f", contentLabelSize.height);
    if (photoimage == nil) {
        NSLog(@"IN1");
        _particularsIV.image = nil;
        CGRect rect = _header.frame;
        rect.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 20;
        _header.frame = rect;
        _deleteTV.tableHeaderView = _header;
        _particularsIV.hidden = YES;
    } else {
        NSLog(@"IN2");
        CGRect rect2 = _header.frame;
        rect2.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 450;
        _header.frame = rect2;
        _deleteTV.tableHeaderView = _header;
        [photoimage getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _particularsIV.image = image;
                });
            }
        }];
        _particularsIV.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _objectsForShow.count;;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    deleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.commentUserDetail.text = [NSString stringWithFormat:@"%@", object[@"commentdetail"]];
    
    PFObject *activity = object[@"commentUser"];
    
    cell.commentName.text =[NSString stringWithFormat:@" %@   评论", activity[@"secondname"]];
    NSLog(@"%@",activity);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.userImage.image = image;
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

/****根据评论的内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    deleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [object[@"commentdetail"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    NSLog(@"origin = %f", cell.commentUserDetail.frame.origin.y);
    NSLog(@"height2 = %f", contentLabelSize.height);
    NSLog(@"totalHeight = %f", cell.commentUserDetail.frame.origin.y + contentLabelSize.height + 20);
    return cell.commentUserDetail.frame.origin.y + contentLabelSize.height + 21;
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem == %@",_item];
    PFQuery *query2 = [PFQuery queryWithClassName:@"comment" predicate:predicate];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *comm in objects) {
                [comm deleteInBackground];
            }
        }
    }];
    
    [_item deleteInBackground];
    
    
    [SVProgressHUD show];
    //判断上传成功
    [_item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)/**/ {
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
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的帖子将彻底删除，您确定要删除吗？" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}

//
//- (void)requestData {
//    
//    //PFQuery *query = [PFQuery queryWithClassName:@"Item"];
//       [SVProgressHUD show];
//    
//    [query2 findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
//        [SVProgressHUD dismiss];
//        
//        if (!error) {
//            _objectsForShow = returnedObjects;
//            NSLog(@"_objectsForShow = %@", _objectsForShow);
//            [_deleteTV reloadData];
//        } else {
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//}
//


- (void)requestData {
    
    _aiv = [Utilities getCoverOnView:self.view];
    [self initializeData];
    
    //    [SVProgressHUD show];
    
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
    //        [SVProgressHUD dismiss];
    //        if (!error) {
    //            _objectsForShow = returnedObjects;
    ////            NSLog(@"%@", _objectsForShow);
    //            [_matchTV reloadData];
    //        } else {
    ////            NSLog(@"Error: %@ %@", error, [error userInfo]);
    //        }
    //    }];
}



//下拉刷新：刷新器+初始数据（第一页数据）
- (void) initializeData
{
    loadCount = 1;//页码为1，从第一页开始
    perPage = 5;//每页显示3个数据
    loadingMore = NO;
    [self urlAction];
}
- (void) urlAction
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem == %@",_item];
    PFQuery *query = [PFQuery queryWithClassName:@"comment" predicate:predicate];
    
    [query includeKey:@"commentUser"];//关联查询
    [query includeKey:@"commentItem"];//关联查询
    
    [query setLimit:perPage];
    [query setSkip:(perPage * (loadCount - 1))];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [_aiv stopAnimating];
        if (!error) {
            NSLog(@"objects = %@", objects);
            if (objects.count == 0) {
                NSLog(@"NO");
                loadCount --;
                [self performSelector:@selector(beforeLoadEnd) withObject:nil afterDelay:0.25];//过0.25秒执行终止操作
            } else {
                if (loadCount == 1) {
                    _objectsForShow = nil;
                    _objectsForShow = [NSMutableArray new];//上拉翻页，新的数据续在第一页的数据之下。若下拉刷新，清空第一二页的内容，然后重新载入第一页的内容
                }
                for (PFObject *obj in objects) {
                    [_objectsForShow addObject:obj];
                }
                NSLog(@"_objectsForShow = %@", _objectsForShow);
                [_deleteTV reloadData];
                [self loadDataEnd];
            }
        } else {
            [self loadDataEnd];
            NSLog(@"%@", [error description]);
        }
    }];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        if (!loadingMore && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height))/**当scrollView的y轴显示位置高度内容大于scrollView的显示高度-scrollView的本身高度**/ {
            [self loadDataBegin];
        }
    } else {
        if (!loadingMore && scrollView.contentOffset.y > 0)/**内容高度大于scrollView本身的高度，执行刷新**/ {
            [self loadDataBegin];
        }
    }
}

- (void)loadDataBegin {
    //这个方法是让上拉时，正在加载时再次上拉时阻断
    if (loadingMore == NO) /**没有在加载**/{
        loadingMore = YES;
        [self createTableFooter];
        _tableFooterAI = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2 - 30.0f, 10.0f, 20.0f, 20.0f)];//创建一个菊花
        [_tableFooterAI setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.deleteTV.tableFooterView addSubview:_tableFooterAI];
        [_tableFooterAI startAnimating];
        [self loadDataing];
    }
}

- (void)loadDataing {
    loadCount ++;
    [self urlAction];
}

- (void)beforeLoadEnd {
    UILabel *label = (UILabel *)[self.deleteTV.tableFooterView viewWithTag:9001];
    [label setText:@"当前已无更多数据"];
    [_tableFooterAI stopAnimating];
    _tableFooterAI = nil;
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];//再过0.25秒执行loadDataEnd
}

- (void)loadDataEnd {
    self.deleteTV.tableFooterView = [[UIView alloc] init];
    loadingMore = NO;
    
}

- (void)createTableFooter {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.deleteTV.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2, 0.0f, 116.0f, 40.0f)];//UI_SCREEN_W 是屏幕的宽度  上拉刷新的Label  让文字和菊花都在正中间
    loadMoreText.tag = 9001;//这个Label的标签是9001
    [loadMoreText setFont:[UIFont systemFontOfSize:B_Font]];
    [loadMoreText setText:@"上拉显示更多数据"];
    loadMoreText.textColor = [UIColor grayColor];
    [tableFooterView addSubview:loadMoreText];
    self.deleteTV.tableFooterView = tableFooterView;
}

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
    [_deleteTV addSubview:refreshControl];
    
    [_deleteTV reloadData];
    
    
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    
    [_deleteTV reloadData];
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
