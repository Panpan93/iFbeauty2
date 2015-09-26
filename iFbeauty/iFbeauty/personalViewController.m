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
- (IBAction)tap:(UITapGestureRecognizer *)sender;

- (IBAction)logout:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)save:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation personalViewController


- (IBAction)tap:(UITapGestureRecognizer *)sender {
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
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    //    上传图片
    PFUser *currentUser = [PFUser currentUser];
    NSData *photoData = UIImagePNGRepresentation(_photoView.image);
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    currentUser[@"photo"] = photoFile;
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
}


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
