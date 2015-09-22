//
//  firstViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "firstViewController.h"
#import "ViewController.h"
#import "SendpostViewController.h"
#import "messageTableViewCell.h"

@interface firstViewController ()

- (IBAction)send:(UIBarButtonItem *)sender;
- (IBAction)mrButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mfButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mtButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)dpButton:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



- (IBAction)send:(UIBarButtonItem *)sender {
    
    SendpostViewController *denglu = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:denglu];
       //动画效果
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //导航条隐藏掉
    nc.navigationBarHidden = YES;
        //类似那个箭头 跳转到第二个界面
    [self presentViewController:nc animated:YES completion:nil];

}


- (void)requestData {
    //    PFUser *currentUser = [PFUser currentUser];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", currentUser];// 查询owner字段为当前用户的所有商品
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", object[@"title"]];
    PFFile *photo = _hh[@"photot"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        }
    }];
    //   NSInteger price = [object[@"price"] integerValue];
    
    
    
    
    
    
    return cell;
}



- (IBAction)mrButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
}

- (IBAction)mfButton:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)mtButton:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)dpButton:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
