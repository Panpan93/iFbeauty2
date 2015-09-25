//
//  personalViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/22.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isedit;
}
@property (weak, nonatomic) IBOutlet UIButton *baocunButton;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *uName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *objectviewshow;
@property(strong,nonatomic)NSMutableArray *objectArray;
@property(strong,nonatomic)NSArray *objects;
//调用
@property(strong,nonatomic)UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIButton *savebutton;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) NSString *secondname;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *xingbie;
//@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *secongemail;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
