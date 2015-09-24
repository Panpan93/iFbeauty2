//
//  shoppingViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/24.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "shoppingViewController.h"

@interface shoppingViewController ()

@end

@implementation shoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopping.multipleTouchEnabled = YES;//启用多个触摸
    _shopping.userInteractionEnabled = YES;//交互
    /*载入百度首页*/
    [self.view insertSubview:self.shopping atIndex:0];
    NSURL *url = [NSURL URLWithString:@"http://www.jd.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_shopping loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate  协议
-(void)webViewDidStartLoad:(UIWebView *)webView// 整体的一个controller类方法, 加载一个菊花图标，当正在访问的时候，一直转//5
{
    [[UIApplication sharedApplication]
     setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView// 访问完成，停止加载时，就不再转
{
    [[UIApplication sharedApplication ]setNetworkActivityIndicatorVisible:NO];
    
}


@end
