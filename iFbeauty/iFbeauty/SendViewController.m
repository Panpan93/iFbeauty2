//
//  SendViewController.m
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/20.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController ()
- (IBAction)pickAction:(UITapGestureRecognizer *)sender;
- (IBAction)saveAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *title = _titleTF.text;
    NSString *detail = _detailTV.text;//得到用户手动输入的东西
    
    //判断照片的情况
    if (_imageView.image == nil) {
        [Utilities popUpAlertViewWithMsg:@"请选择一张照片" andTitle:nil];
        return;
    }
//    if ([title isEqualToString:@""] || [detail isEqualToString:@""]) {
//        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
//        return;
//    }
    
    //创建一个item
    PFObject *item = [PFObject objectWithClassName:@"Item"];
    item[@"title"] = title;
    item[@"detail"] = detail;
    item[@"comment"] = @"";
        
    //设置照片的上传
    NSData *photoData = UIImagePNGRepresentation(_imageView.image);
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    item[@"photot"] = photoFile;
    
    //设置照片的关联
    PFUser *currentUser = [PFUser currentUser];
    item[@"owner"] = currentUser;
    
    //调出菊花  活动指示器
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    //判断上传成功
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)/*如果成功的插入数据库*/ {
        [aiv stopAnimating];
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];//通过通知去刷新列表。自动刷新，
            [self.navigationController popViewControllerAnimated:YES];//刷新页面
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];

}

- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2)
        return;
    
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;//可编辑
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}

//取出已经编辑过的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//键盘点击空白回收
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//textView 的键盘回收
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
