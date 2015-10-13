//
//  firstViewController.h
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/19.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface firstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
        BOOL loadingMore;
        NSInteger loadCount;
        NSInteger perPage;
        NSInteger totalPage;
}


@property (strong, nonatomic) NSMutableArray *objectsForShow;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) NSMutableArray * slideImages;

@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@property (strong, nonatomic) UIActivityIndicatorView *tableFooterAI;

@end
