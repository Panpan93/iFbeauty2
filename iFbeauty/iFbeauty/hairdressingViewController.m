//
//  hairdressingViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "hairdressingViewController.h"
#import "hairdressingTableViewCell.h"

@interface hairdressingViewController ()

@end

@implementation hairdressingViewController

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typetei == '关于美容'"];
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];

    [query includeKey:@"owner"];//关联查询
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_hairdressingTV reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_objectsForShow count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hairdressingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hairdressingCell" forIndexPath:indexPath];//复用Cell
    
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
