//
//  bodybuildingViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "bodybuildingViewController.h"
#import "bodybuildingTableViewCell.h"
#import "particularsViewController.h"

@interface bodybuildingViewController ()

@end

@implementation bodybuildingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    [self uiConfiguration];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];

    
    self.navigationItem.title = [NSString stringWithFormat:@"美体"];
    _bodybuildingTV.tableFooterView=[[UIView alloc]init];//不显示多余的分隔符
    
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

//取消选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    particularsViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"particulars"];
    PFObject *par = object[@"owner"];
    pvc.ownername = par;
    pvc.item = object;
    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    [self.navigationController pushViewController:pvc animated:YES];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_objectsForShow count];
}

/****根据评论的内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    bodybuildingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodybuildingCell"];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [object[@"title"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.userTitle.font} context:nil].size;
    NSLog(@"origin = %f", cell.userTitle.frame.origin.y);
    NSLog(@"height = %f", contentLabelSize.height);
    NSLog(@"totalHeight = %f", cell.userTitle.frame.origin.y + contentLabelSize.height + 20);
    return cell.userTitle.frame.origin.y + contentLabelSize.height + 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    bodybuildingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodybuildingCell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.userTitle.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    
    PFObject *activity = object[@"owner"];
    
    cell.userName.text =[NSString stringWithFormat:@"发帖人： %@", activity[@"username"]];
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
    cell.userDate.text = [NSString stringWithFormat:@"%@",strDate];

    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (void)requestData {
    
    _aiv = [Utilities getCoverOnView:self.view];
    [self initializeData];
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typetei == '关于美体'"];
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    [query includeKey:@"owner"];//关联查询
    
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
                [_bodybuildingTV reloadData];
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
        [self.bodybuildingTV.tableFooterView addSubview:_tableFooterAI];
        [_tableFooterAI startAnimating];
        [self loadDataing];
    }
}

- (void)loadDataing {
    loadCount ++;
    [self urlAction];
}

- (void)beforeLoadEnd {
    UILabel *label = (UILabel *)[self.bodybuildingTV.tableFooterView viewWithTag:9001];
    [label setText:@"当前已无更多数据"];
    [_tableFooterAI stopAnimating];
    _tableFooterAI = nil;
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];//再过0.25秒执行loadDataEnd
}

- (void)loadDataEnd {
    self.bodybuildingTV.tableFooterView = [[UIView alloc] init];
    loadingMore = NO;
    
}

- (void)createTableFooter {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bodybuildingTV.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2, 0.0f, 116.0f, 40.0f)];//UI_SCREEN_W 是屏幕的宽度  上拉刷新的Label  让文字和菊花都在正中间
    loadMoreText.tag = 9001;//这个Label的标签是9001
    [loadMoreText setFont:[UIFont systemFontOfSize:B_Font]];
    [loadMoreText setText:@"上拉显示更多数据"];
    loadMoreText.textColor = [UIColor grayColor];
    [tableFooterView addSubview:loadMoreText];
    self.bodybuildingTV.tableFooterView = tableFooterView;
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
    [_bodybuildingTV addSubview:refreshControl];
    
    [_bodybuildingTV reloadData];
    
    
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    
    [_bodybuildingTV reloadData];
    //怎么样让方法延迟执行的
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
}
//闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}



@end

