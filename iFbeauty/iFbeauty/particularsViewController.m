//
//  particularsViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/23.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "particularsViewController.h"
#import "hairdressingTableViewCell.h"
#import "readcommentTableViewCell.h"

@interface particularsViewController ()
- (IBAction)praiseAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)commentAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation particularsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];

    PFFile *userphoto = _item[@"photot"];
    
    _userName.text =[NSString stringWithFormat:@"发帖人： %@", _ownername[@"secondname"]];
    NSLog(@"用户名%@",_userName.text);

    
    _userTitle.text = _item[@"title"];
    _deLabel.text =[NSString stringWithFormat:@"%@", _item[@"detail"]];
    PFFile *photo = _ownername[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _userImage.image = image;
            });
        }
    }];
    
    NSLog(@"y = %f", _deLabel.frame.origin.y);
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 40, 1000);
    CGSize contentLabelSize = [_deLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_deLabel.font} context:nil].size;
    NSLog(@"height = %f", contentLabelSize.height);
    if (userphoto == nil) {
        _userImage.image = nil;
        CGRect rect = _header.frame;
        rect.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 20;
        _header.frame = rect;
        _tableView.tableHeaderView.frame = rect;
        _particularsIV.hidden = YES;
    } else {
        CGRect rect2 = _header.frame;
        rect2.size.height = _deLabel.frame.origin.y + contentLabelSize.height + 440;
        _header.frame = rect2;
        _tableView.tableHeaderView.frame = rect2;
        [userphoto getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _particularsIV.image = image;
                });
            }
        }];
        _particularsIV.hidden = NO;
    }
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


- (IBAction)praiseAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)commentAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (void)requestData {
    
    //PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentItem == %@",_item];
    PFQuery *query2 = [PFQuery queryWithClassName:@"comment" predicate:predicate];
    
    [query2 includeKey:@"commentUser"];//关联查询
    [query2 includeKey:@"commentItem"];//关联查询
    [SVProgressHUD show];

    [query2 findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [SVProgressHUD dismiss];

        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    readcommentTableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//    
//    
//
//}
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    readcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.commentUserDetail.text = [NSString stringWithFormat:@"%@", object[@"commentdetail"]];
    
    PFObject *activity = object[@"commentUser"];
    
    cell.commentUserName.text =[NSString stringWithFormat:@" %@   评论", activity[@"secondname"]];
    NSLog(@"%@",activity);
    PFFile *photo = activity[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.commentUserImage.image = image;
            });
        }
    }];
    
    return cell;
    
}

@end
