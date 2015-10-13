//
//  fansViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "fansViewController.h"
#import "fansTableViewCell.h"
#import "focusPeopleViewController.h"
#import "fansPeopleViewController.h"

@interface fansViewController ()

@end

@implementation fansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshHome" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
     _tableview.tableFooterView=[[UIView alloc]init];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//视图出现之前做的事情
    [self requestData];
    
}



- (void)requestData {
    
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"focus == %@", currentUser];// 查询focusecond字段为当前用户的所有
    PFQuery *query = [PFQuery queryWithClassName:@"Concern" predicate:predicate];
    NSLog(@"predicate == %@",predicate);
    NSLog(@"query == %@",query);
    
    
    [query includeKey:@"focusecond"];//关联查询
    
    [SVProgressHUD show];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableview reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    fansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fans" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *activity = object[@"focusecond"];
    
    
    cell.name.text =[NSString stringWithFormat:@"%@", activity[@"secondname"]];
    cell.xinxi.text = [NSString stringWithFormat:@"%@",activity[@"username"]];
    
    NSLog(@"%@",object);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = image;
            });
        }
    }];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    fansPeopleViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"fansPeople"];
    PFObject *par = object[@"focusecond"];
    //    pvc.ownername = par;
    //    pvc.item = object;
    pvc.chuanru = par;
    pvc.obj = object;
    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    [self.navigationController pushViewController:pvc animated:YES];
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"guanzhu"]) {
//
//        PFObject *object = [_objectsForShow objectAtIndex:[_focusTable indexPathForSelectedRow].row];//获得当前tableview选中航的数据
//        focusPeopleViewController *miVC = segue.destinationViewController;//目的地视图控制器
//        PFObject *Buser = object[@"focus"];
//        miVC.chuanru = Buser;
//        miVC.hidesBottomBarWhenPushed = YES;
//    }
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
//    fansTableViewCell *pvc = [Utilities getStoryboardInstanceByIdentity:@"focusPeople"];
//    PFObject *par = object[@"focus"];
//    //    pvc.ownername = par;
//    //    pvc.item = object;
////    pvc.chuanru = par;
////    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
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
