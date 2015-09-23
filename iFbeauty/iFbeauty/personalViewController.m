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

- (IBAction)save:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation personalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectviewshow=[[NSMutableArray alloc]initWithObjects:@"昵称",@"个性签名",@"性别",@"年龄",@"地址",@"邮箱", nil];
    isedit = NO;
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
    _uName.text = currentUser[@"username"];
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
    user = [_objectArray objectAtIndex:indexPath.row];
    NSLog(@"   111111111%@",_objectArray);

    cell.editable = isedit;
    
    if (indexPath.row==0) {
        
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"username"]];
        
    }else if (indexPath.row==1)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"signature"]];
    }
    else if (indexPath.row==2)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"xingbie"]];
    }
    else if (indexPath.row==3)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"age"]];
    }
    else if (indexPath.row==4)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"address"]];
    }
    else if (indexPath.row==5)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", user[@"age"]];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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
- (IBAction)save:(UIButton *)sender forEvent:(UIEvent *)event {
    
        if(isedit == NO)
        {
    
            isedit=YES;
            //        UIButton *b=(UIButton *)[self.view viewWithTag:800];
            //        b.userInteractionEnabled=YES;
            [_button setTitle:@"保存" forState:UIControlStateNormal];
            [_tableView reloadData];
        }
        else if([_button.titleLabel.text isEqualToString:@"保存"])
        {
            //        UIButton *b=(UIButton *)[self.view viewWithTag:800];
            //        b.userInteractionEnabled=NO;
            isedit=NO;
            [_button setTitle:@"编辑" forState:UIControlStateNormal];
            [_tableView reloadData];
        }
        
    

}
@end
