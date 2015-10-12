//
//  postViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "postViewController.h"
#import "deleteViewController.h"

@interface postViewController ()

@end

@implementation postViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshHome" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
 _postTable.tableFooterView=[[UIView alloc]init];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//视图出现之前做的事情
    [self readData];
    
}



-(void)readData
{
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner == %@", currentUser];// 查询owner字段为当前用户的所有
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
//    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
//        [aiv stopAnimating];
        if (!error) {
            _postArray = returnedObjects;
            NSLog(@"%@", _postArray);
            [_postTable reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_postArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postcell" forIndexPath:indexPath];
    
    PFObject *object = [_postArray objectAtIndex:indexPath.row];
    
          if (!(object[@"title"])) {
              
           cell.textLabel.text =@"";
        }

    cell.textLabel.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    //自动换行，
    cell.textLabel.numberOfLines = 0;


    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *object = [_postArray objectAtIndex:indexPath.row];
    deleteViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"delete"];
    PFObject *par = object[@"owner"];
    pvc.ownername = par;
    pvc.item = object;
    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    [self.navigationController pushViewController:pvc animated:YES];
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
//    particularsViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"particulars"];
//    PFObject *par = object[@"owner"];
//    pvc.ownername = par;
//    pvc.item = object;
//    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
//    [self.navigationController pushViewController:pvc animated:YES];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
