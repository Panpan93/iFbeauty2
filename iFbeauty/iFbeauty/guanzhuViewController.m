//
//  guanzhuViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/8.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "guanzhuViewController.h"
#import "guanzhuTableViewCell.h"

@interface guanzhuViewController ()

@end

@implementation guanzhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshHome" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//视图出现之前做的事情
    [self requestData];
    
}



- (void)requestData {
    
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"focusecond == %@", currentUser];// 查询focusecond字段为当前用户的所有
    PFQuery *query = [PFQuery queryWithClassName:@"Concern" predicate:predicate];
    NSLog(@"predicate == %@",predicate);
    NSLog(@"query == %@",query);
    
    
    [query includeKey:@"focus"];//关联查询
    
    [SVProgressHUD show];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_focusTable reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    guanzhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guanzhu" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *activity = object[@"focus"];
    
    
    cell.focusName.text =[NSString stringWithFormat:@"%@", activity[@"secondname"]];
    cell.focusXinxi.text = [NSString stringWithFormat:@"%@",activity[@"username"]];
    
    NSLog(@"%@",object);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.userimage.image = image;
            });
        }
    }];
    
    
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

@end
