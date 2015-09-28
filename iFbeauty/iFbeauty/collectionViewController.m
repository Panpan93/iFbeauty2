//
//  collectionViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/28.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "collectionViewController.h"

@interface collectionViewController ()

@end

@implementation collectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionData
{

    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shoucangitem==%@",currentUser];
    PFQuery *collection = [PFQuery queryWithClassName:@"collection" predicate:predicate];
    NSLog(@"collection == %@ ",collection);
    [collection includeKey:@"shoucangitem"];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [collection findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _collectionArray = returnedObjects;
            NSLog(@"%@", _collectionArray);
            [_collectionTable reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_collectionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collection" forIndexPath:indexPath];
    
    PFObject *object = [_collectionArray objectAtIndex:indexPath.row];
    PFObject *activity = object[@"shoucangitem"];

    
    if (!(activity[@"title"])) {
        
        cell.textLabel.text =@"";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", activity[@"title"]];
    NSLog(@"cell == %@",cell.textLabel.text);
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PFObject *object = [_postArray objectAtIndex:indexPath.row];
//    deleteViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"delete"];
//    PFObject *par = object[@"owner"];
//    pvc.ownername = par;
//    pvc.item = object;
//    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
//    [self.navigationController pushViewController:pvc animated:YES];
    
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
