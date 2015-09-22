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

    // Do any additional setup after loading the view.
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



- (IBAction)send:(UIBarButtonItem *)sender {
    
    SendpostViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    denglu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:denglu animated:YES];
}


- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query includeKey:@"owner"];//关联查询
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
         
            NSLog(@"%@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    
    //    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    //    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    //    NSString *dateString = [dateFormat stringFromDate:object[@"createdAt"]]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    //    cell.datalabel.text = [NSString stringWithFormat:@"%@", dateString];
    
    //    PFUser *user = [PFUser user];
    PFObject *activity = object[@"owner"];
    
    cell.nameLabel.text =[NSString stringWithFormat:@"发帖人： %@", activity[@"username"]];
    NSLog(@"%@",activity);
    PFFile *photo = object[@"photot"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageview.image = image;
            });
        }
    }];
    //   NSInteger price = [object[@"price"] integerValue];
    
    return cell;
}



- (IBAction)mrButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
}

- (IBAction)mfButton:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)mtButton:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)dpButton:(UIButton *)sender forEvent:(UIEvent *)event {
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