//
//  secondViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface secondViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BOOL loadingMore;
    NSInteger loadCount;
    NSInteger perPage;
    NSInteger totalPage;
}

@property (strong, nonatomic) NSArray *objectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) UIActivityIndicatorView *tableFooterAI;

@property (weak, nonatomic) IBOutlet UITableView *secondTable;
//@property (strong, nonatomic) NSArray *objectsForShow;

@end
