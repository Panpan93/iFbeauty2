//
//  MineViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/20.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()
- (IBAction)post:(UIButton *)sender forEvent:(UIEvent *)event;//帖子
- (IBAction)focus:(UIButton *)sender forEvent:(UIEvent *)event;//关注
- (IBAction)fans:(UIButton *)sender forEvent:(UIEvent *)event;//粉丝

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectforshow=[[NSMutableArray alloc]initWithObjects:@"百度新闻",@"我的收藏",@"我的相册",@"购物",@"设置", nil];
//    _tableIV.delegate=self;
//    _tableIV.dataSource=self;
    _tableIV.tableFooterView=[[UIView alloc]init];//不显示多余的分隔符
}

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)post:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)focus:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)fans:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
