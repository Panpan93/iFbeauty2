//
//  collectionViewController.h
//  iFbeauty
//
//  Created by 王梦雅 on 15/9/28.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *collectionTable;
@property(strong,nonatomic)NSArray *collectionArray;
@property (strong, nonatomic) PFObject *item;
@property (strong, nonatomic) PFObject *ownername;


@end
