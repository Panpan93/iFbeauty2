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
    
    [self readFocus];
}
-(void)readFocus
{
//  PFQuery *query= [PFQuery queryWithClassName:@"Concern"];
//    [query findObjectsInBackgroundWithBlock:(int number, NSError *error)
//     {}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objectsForShow count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    guanzhuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"guanzhu" forIndexPath:indexPath];

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
