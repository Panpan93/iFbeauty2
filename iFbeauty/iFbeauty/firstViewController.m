//
//  firstViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "firstViewController.h"
#import "ViewController.h"
#import "SendpostViewController.h"
#import "messageTableViewCell.h"
#import "hairdressingViewController.h"
#import "meifaViewController.h"
#import "bodybuildingViewController.h"
#import "matchViewController.h"
#import "particularsViewController.h"


@interface firstViewController ()

- (IBAction)send:(UIBarButtonItem *)sender;
- (IBAction)mrButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mfButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mtButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dpButton:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self uiConfiguration];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tupian1.jpg"]];

    
    [self.navigationController.navigationBar setTranslucent:NO];
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    
    // 初始化 数组 并添加六张图片
    _slideImages = [[NSMutableArray alloc] init];
    [_slideImages addObject:@"lunbo1.jpg"];
    [_slideImages addObject:@"lunbo2.jpg"];
    [_slideImages addObject:@"lunbo3.jpg"];
    [_slideImages addObject:@"lunbo4.jpg"];
    [_slideImages addObject:@"lunbo5.jpg"];
    
    //[_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    //[_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    _pageControl.numberOfPages = [self.slideImages count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    
    //创建6个图片
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake((UI_SCREEN_W * i) + UI_SCREEN_W, 0,UI_SCREEN_W, 150);
        [_scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+UI_SCREEN_W。。。
    }
    
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, UI_SCREEN_W,150); // 添加最后1页在首页 循环
    [_scrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((UI_SCREEN_W * ([_slideImages count] + 1)) , 0,UI_SCREEN_W, 150); // 添加第1页在最后 循环
    [_scrollView addSubview:imageView];
    
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_W * ([_slideImages count] + 2), 150)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([_slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * [_slideImages count],0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([_slideImages count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    long page = _pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W*(page+1),0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    long page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page >=5 ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}

//点击发帖按钮
- (IBAction)send:(UIBarButtonItem *)sender {
    
    SendpostViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    denglu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:denglu animated:YES];
}


- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query includeKey:@"owner"];//关联查询
      UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
            [aiv stopAnimating];
        if (!error) {
            _objectsForShow = returnedObjects;
//            NSLog(@"%@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

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



// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
//     if ([segue.identifier isEqualToString:@"particulars"]) {
//         PFObject *object = [_objectsForShow objectAtIndex:[_tableView indexPathForSelectedRow].row];//获得当前tablview选中行的数据
//         particularsViewController *miVC = segue.destinationViewController;//目的地视图控制器
//         PFObject *par = object[@"owner"];
//         miVC.item = object;
//         miVC.ownername = par;
//         miVC.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
//         //
//     }
//
// }
//


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_objectsForShow count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    messageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    
    PFObject *activity = object[@"owner"];
      
    cell.nameLabel.text =[NSString stringWithFormat:@"发帖人： %@", activity[@"username"]];
    NSLog(@"%@",activity);
    PFFile *photo = object[@"photot"];
    if (photo == NULL) {
        cell.imageview.image = nil;
    } else
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageview.image = image;
            });
        }
    }];
    
    return cell;
}


//美容按钮
- (IBAction)mrButton:(UIButton *)sender forEvent:(UIEvent *)event {
    hairdressingViewController *meir = [self.storyboard instantiateViewControllerWithIdentifier:@"meirong"];
    meir.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meir animated:YES];

}

//美发按钮
- (IBAction)mfButton:(UIButton *)sender forEvent:(UIEvent *)event {
    meifaViewController *meif = [self.storyboard instantiateViewControllerWithIdentifier:@"meifa"];
    meif.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meif animated:YES];

}

//美体按钮
- (IBAction)mtButton:(UIButton *)sender forEvent:(UIEvent *)event {
    bodybuildingViewController *meif = [self.storyboard instantiateViewControllerWithIdentifier:@"bodybuilding"];
    meif.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meif animated:YES];
}

//搭配按钮
- (IBAction)dpButton:(UIButton *)sender forEvent:(UIEvent *)event {
    matchViewController *meif = [self.storyboard instantiateViewControllerWithIdentifier:@"match"];
    meif.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meif animated:YES];
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
@end