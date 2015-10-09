//
//  secondViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "secondViewController.h"
#import "secondTableViewCell.h"
#import "commentViewController.h"


@interface secondViewController ()


@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tupian1.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];
//      _secondTable.separatorColor = [UIColor colorWithRed: 159/255.0 green:159/255.0 blue:159/255.0 alpha:0.4];//换行线颜色
         _secondTable.separatorColor = [UIColor grayColor];//换行线颜色

    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//视图出现之前做的事情
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {

    PFUser *currentUser = [PFUser currentUser];
    
    //当前用户发的帖子
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"owner == %@",currentUser];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Item" predicate:predicate2];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem.owner == %@", currentUser];// 查询owner字段为当前用户的所有
    //查询帖子的评论
    PFQuery *query = [PFQuery queryWithClassName:@"comment"];
    [query whereKey:@"commentItem" matchesQuery:query2];
    [query includeKey:@"commentItem.owner"];
    [query includeKey:@"commentUser"];
    [query orderByDescending:@"createdAt"];
    
    
    [SVProgressHUD show];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_secondTable reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//跳转下一页并传值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    commentViewController *pvc = [Utilities getStoryboardInstanceByIdentity:@"comment"];
    
    pvc.commentobject = object;
    
    PFObject *par = object[@"commentItem"];
    pvc.commentItem = par;

    pvc.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    [self.navigationController pushViewController:pvc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    secondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaicell" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *activity = object[@"commentUser"];
    PFObject *activity2 = object[@"commentItem"];
    
    
    cell.name.text =[NSString stringWithFormat:@"%@", activity[@"secondname"]];
    cell.tiezi.text = [NSString stringWithFormat:@"%@",activity2[@"title"]];
    
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
    
    NSDate *createdAt = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:createdAt];
    cell.commentdate.text = [NSString stringWithFormat:@"%@",strDate];

    
    
    return cell;
    
}


/****根据评论的内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    secondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaicell"];
    
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *activity2 = object[@"commentItem"];
    
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [activity2[@"title"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    return cell.tiezi.frame.origin.y + contentLabelSize.height + 21;
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
