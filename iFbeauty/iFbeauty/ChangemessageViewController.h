//
//  ChangemessageViewController.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/20.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangemessageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@end
