//
//  readPostViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "readPostViewController.h"
#import "postDetailViewController.h"

@interface readPostViewController ()

@end

@implementation readPostViewController

- (void)viewDidLoad {
//    _duqu.text=_chuanru;
    [super viewDidLoad];
   
    [self readData];
}
-(void)readData
{
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"owner == %@ ",_chuanru];
    
    PFQuery *query=[PFQuery queryWithClassName:@"Item"predicate:predicate];
    
    [query includeKey:@"owner"];//关联查询
        
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            
            _objectShow = returnedObjects;
            NSLog(@"读取 = %@", _objectShow);
            [_readTable reloadData];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objectShow count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readcell" forIndexPath:indexPath];
    PFObject *object = [_objectShow objectAtIndex:indexPath.row];
    
    //PFObject *activity = object[@"owner"];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@", object[@"title"]];
    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.text=_chuanru;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *object = [_objectShow objectAtIndex:indexPath.row];
    postDetailViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"postdetail"];
  PFObject *par = object[@"owner"];
     pvc.xinxi = par;
//    pvc.chuanru = _chuanru;
    pvc.item = object;
    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    [self.navigationController pushViewController:pvc animated:YES];
    
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
