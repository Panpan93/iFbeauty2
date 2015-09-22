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

@end

@implementation personalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectviewshow=[[NSMutableArray alloc]initWithObjects:@"昵称",@"个性签名",@"性别",@"年龄",@"地址",@"邮箱", nil];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取数据

- (void)requestData {
    PFUser *currentUser = [PFUser currentUser];
    
    PFFile *photo = currentUser[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoView.image = image;
                
            });
        }
    }];
    _uName.text = currentUser[@"username"];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [_objectviewshow count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    personalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];//复用Cell
        cell.userName .text =[_objectviewshow objectAtIndex:indexPath.row];
      PFObject *object = [_objectArray objectAtIndex:indexPath.row];
    if (indexPath.row==1) {
        
        cell.editor.text=[NSString stringWithFormat:@"%@", object[@"username"]];
        
    }else if (indexPath.row==2)
    {
     cell.editor.text=[NSString stringWithFormat:@"%@", object[@"signature"]];
    }
    else if (indexPath.row==3)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", object[@"xingbie"]];
    }
    else if (indexPath.row==4)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", object[@"age"]];
    }
    else if (indexPath.row==5)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", object[@"address"]];
    }
    else if (indexPath.row==6)
    {
        cell.editor.text=[NSString stringWithFormat:@"%@", object[@"age"]];
    }

    
    //   NSInteger price = [object[@"price"] integerValue];
    
    
    return cell;
}

@end
