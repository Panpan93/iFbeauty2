//
//  fansPeopleViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/10/13.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "fansPeopleViewController.h"
#import "readPostViewController.h"

@interface fansPeopleViewController ()
- (IBAction)guanzhu:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)chakan:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation fansPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self quxiaoData];
    [self focusData];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tupian1.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background4"]];
    
    
    [self readData];
    PFFile *imageview = _chuanru[@"photo"];
    [imageview getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photo.image = image;
            });
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)readData
{
    _nicheng.text=_chuanru[@"secondname"];
    _xingbie.text=_chuanru[@"xingbie"];
    _qianming.text=_chuanru[@"signature"];
    _dizhi.text=_chuanru[@"address"];
    _zhanghao.text=_chuanru[@"username"];
    _youxiang.text=_chuanru[@"secongemail"];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


//关注

- (IBAction)guanzhu:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    if ([_guanzhu.titleLabel.text isEqualToString:@"我要关注"]) {
        PFUser *current=[PFUser currentUser];
        PFObject *focus = [PFObject objectWithClassName:@"Concern"];
        //关注的人
        focus[@"focus"] = _obj[@"username"];
        //当前登陆的用户
        focus[@"focusecond"] = current;
        
        [focus saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [SVProgressHUD show];
            if (succeeded){
                [SVProgressHUD dismiss];
                [Utilities popUpAlertViewWithMsg:@"关注成功！" andTitle:nil];
                NSLog(@"Object Uploaded!");
                [self focusData];
            }
            else{
                NSLog(@"error=%@",error);
            }
        }];
    } else {
        if ([_guanzhu.titleLabel.text isEqualToString:@"取消关注"])
        {
            [SVProgressHUD dismiss];
            [Utilities popUpAlertViewWithMsg:@"取消关注成功！" andTitle:nil];
            
            [self quxiaoData];
        }
        
    }
}
-(void)quxiaoData
{
    PFUser *current=[PFUser currentUser];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_obj[@"username"], current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
    NSLog(@" query3  == %@ ",query3);
    
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (!number == 0) {
                PFUser *current=[PFUser currentUser];
                
                NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_obj[@"username"], current];
                
                PFQuery *query4 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
                
                [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *quxiao in objects) {
                            [quxiao deleteInBackground];
                        }
                    }
                }];
                
                //                [_ownername deleteInBackground];
                
                
                
            }
        }
        else{
            NSLog(@"error=%@",error);
        }
        
    }];
    
    
    
}


-(void)focusData
{
    PFUser *current=[PFUser currentUser];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" focus == %@ AND focusecond == %@",_obj[@"username"], current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"Concern" predicate:predicate3];
    NSLog(@" query3  == %@ ",query3);
    
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == 0) {
                _guanzhu.titleLabel.text=@"我要关注";
            } else {
                _guanzhu.titleLabel.text=@"取消关注";
            }
        }
        else{
            NSLog(@"error=%@",error);
        }
    }];
    
    
}


//-(void)quxiaoData {
//    [_obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            [Utilities popUpAlertViewWithMsg:@"关注成功" andTitle:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
//}
//
- (IBAction)chakan:(UIButton *)sender forEvent:(UIEvent *)event {
    
    readPostViewController *read = [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    //    NSString *name=_zhanghao.text;
    //    PFObject *par = name[@"focus"];
    
    read.chuanru = _chuanru;
    
    read.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:read animated:YES];
    
}
@end
