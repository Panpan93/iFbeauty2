//
//  readPostViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/10/9.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "readPostViewController.h"

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
     PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@" focus == %@ AND focusenced ==%@",_chuanru,currentUser];
    PFQuery *query=[PFQuery queryWithClassName:@"Concern"predicate:predicate];
   
    
    //    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        //        [aiv stopAnimating];
        if (!error) {
          
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
//    cell.textLabel.text=_chuanru;
    
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
