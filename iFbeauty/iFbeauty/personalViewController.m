//
//  personalViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/22.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "personalViewController.h"
#import "personalTableViewCell.h"

@interface personalViewController ()
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender;
- (IBAction)logout:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)save:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation personalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    CALayer *layer = [_baocunButton layer];
    layer.cornerRadius = 40;//角的弧度
    layer.borderColor = [[UIColor redColor]CGColor];
    layer.borderWidth = 1;//边框宽度
    layer.masksToBounds = YES;//图片填充边框
    _objectviewshow=[[NSMutableArray alloc]initWithObjects:@"昵称",@"个性签名",@"性别",@"地址",@"邮箱", nil];
    isedit = NO;
    _savebutton.hidden = YES;
    [self requestData];
    [self creatbutton];
}


//点击return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
//点击空白处键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取数据

- (void)requestData {
    PFUser *currentUser = [PFUser currentUser];
    _uName.text = [NSString stringWithFormat:@"账号信息：%@", currentUser[@"username"]];
    PFFile *photo = currentUser[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoView.image = image;
                [_tableView reloadData];
            });
        }
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [_objectviewshow count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    personalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.userName .text =[_objectviewshow objectAtIndex:indexPath.row];
  //  PFObject *object = [_objectArray objectAtIndex:indexPath.row];

    PFUser *user = [PFUser currentUser];
//    user = [_objectArray objectAtIndex:indexPath.row];
//    PFUser *user = [PFUser currentUser];
    NSLog(@"%@", user);


    cell.editable = isedit;
    
    
    if (indexPath.row==0) {
        if (!(user[@"secondname"])) {
            cell.editor.text=@"";
        }else
        {
            cell.editor.text=[NSString stringWithFormat:@"%@", user[@"secondname"]];
        }
        
    }else if (indexPath.row==1)
    {
        if (!(user[@"signature"])) {
            cell.editor.text=@"";
        }else
        {
            
            cell.editor.text=[NSString stringWithFormat:@"%@", user[@"signature"]];
        }
    }
    else if (indexPath.row==2)
    {
        if (!(user[@"xingbie"])) {
            cell.editor.text=@"";
        }else
        {
            
            cell.editor.text=[NSString stringWithFormat:@"%@", user[@"xingbie"]];
        }
    }
    //    else if (indexPath.row==3)
    //    {
    //        if (!(user[@"age"])) {
    //            cell.editor.text=@"";
    //        }else
    //        {
    //        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"age"]];
    //        }
    //    }
    else if (indexPath.row==3)
    {
        if (!(user[@"address"])) {
            cell.editor.text=@"";
        }else
        {
            cell.editor.text=[NSString stringWithFormat:@"%@", user[@"address"]];
        }
    }
    else if (indexPath.row==4)
    {
        if (!(user[@"email"])) {
            cell.editor.text=@"";
        }else
        {
            cell.editor.text=[NSString stringWithFormat:@"%@", user[@"email"]];
        }
    }
    
    if (isedit == YES) {
        if (indexPath.row==0) {
            if (!(cell.editor.text)) {
                _secondname = @"";
            }
            _secondname = cell.editor.text;
        }else if (indexPath.row==1)
        {
            if (!(cell.editor.text)) {
                _signature = @"";
            }
            _signature = cell.editor.text;
        }
        else if (indexPath.row==2)
        {
            if (!(cell.editor.text)) {
                _xingbie = @"";
            }
            _xingbie = cell.editor.text;
        }
        //        else if (indexPath.row==3)
        //        {
        //            _age = cell.editor.text;
        //        }
        else if (indexPath.row==3)
        {
            if (!(cell.editor.text)) {
                _address = @"";
            }
            _address = cell.editor.text;
        }
        else if (indexPath.row==4)
        {
            if (!(cell.editor.text)) {
                _secongemail = @"";
            }
            _secongemail = cell.editor.text;
        }
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)creatbutton
{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.translucent=NO;
    _button.titleLabel.text=@"编辑";
    
}
#pragma mark-保存按钮的点击事件
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    return YES;//可编辑
//}
//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//
//    return YES;//可清除内容
//}

- (IBAction)logout:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"B: %@", _secondname);
    
    personalTableViewCell *cell1 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    user[@"secondname"] = cell1.editor.text;
    
    personalTableViewCell *cell2 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    user[@"signature"] = cell2.editor.text;
    
    personalTableViewCell *cell3 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    user[@"xingbie"] = cell3.editor.text;
    
    //    personalTableViewCell *cell4 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    //    user[@"age"] = cell4.editor.text;
    
    personalTableViewCell *cell4 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    user[@"address"] = cell4.editor.text;
    
    personalTableViewCell *cell5 = (personalTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    user[@"secongemail"] = cell5.editor.text;
    
    [SVProgressHUD show];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [SVProgressHUD dismiss];
            [self requestData];
        } else {
            
        }
    }];
    isedit=NO;
    [_button setTitle:@"编辑" forState:UIControlStateNormal];
    _savebutton.hidden = YES;
    
    

    
}

- (IBAction)save:(UIButton *)sender forEvent:(UIEvent *)event {
    
        if(isedit == NO)
        {
    
            isedit=YES;
            [_button setTitle:@"取消" forState:UIControlStateNormal];
            _savebutton.hidden = NO;

            [_tableView reloadData];
        }
        else if([_button.titleLabel.text isEqualToString:@"取消"])
        {
            isedit=NO;
            [_button setTitle:@"编辑" forState:UIControlStateNormal];
            _savebutton.hidden = YES;

            [_tableView reloadData];
        }
        
    

}
@end
