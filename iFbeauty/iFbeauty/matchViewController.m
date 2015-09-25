//
//  matchViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "matchViewController.h"
#import "matchTableViewCell.h"
#import "particularsViewController.h"

@interface matchViewController ()

@end

@implementation matchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
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
- (void)requestData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typetei == '关于搭配'"];
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    [query includeKey:@"owner"];//关联查询
    
    [SVProgressHUD show];

    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_matchTV reloadData];
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_objectsForShow count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    matchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];//复用Cell
    
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
    
    return cell;
}

@end
