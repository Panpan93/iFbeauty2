//
//  choosetypeViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/21.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "choosetypeViewController.h"

@interface choosetypeViewController ()

@end

@implementation choosetypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
   // _tableView.tableFooterView = [[UIView alloc] init]; //去掉多余的tableView下划线
}

- (void)requestData {
    //    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
   
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
            NSLog(@"%@",query);

            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//返回tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell

    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", object[@"type"]];
    
    return cell;
    
    
    }

//取消选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

@end
