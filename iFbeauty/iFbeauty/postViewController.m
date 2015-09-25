//
//  postViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/25.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "postViewController.h"
#import "postCellTableViewCell.h"


@interface postViewController ()

@end

@implementation postViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    
}
-(void)readData
{
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner == %@", currentUser];// 查询owner字段为当前用户的所有商品
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
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
    postCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postcell" forIndexPath:indexPath];
    
    PFObject *object = [_postArray objectAtIndex:indexPath.row];
    
          if (!(object[@"title"])) {
            cell.postLabel.text=@"";
        }

    cell.postLabel.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    
    
    

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
