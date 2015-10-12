//
//  NewsViewController.m
//  iFbeauty
//
//  Created by  张艳芳 on 15/9/21.
//  Copyright (c) 2015年 第八组. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webview.multipleTouchEnabled = YES;//启用多个触摸
    _webview.userInteractionEnabled = YES;//交互
    /*载入百度首页*/
    [SVProgressHUD show];

    
    [self.view insertSubview:self.webview atIndex:0];
    NSURL *url = [NSURL URLWithString:@"http://www.yoka.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    
//    [self loadToolBar];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3"]];


}
#pragma UIWebViewDelegate  协议
-(void)webViewDidStartLoad:(UIWebView *)webView// 整体的一个controller类方法, 加载一个菊花图标，当正在访问的时候，一直转//5
{
    [[UIApplication sharedApplication]
     setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView// 访问完成，停止加载时，就不再转
{
    [SVProgressHUD dismiss];

    [[UIApplication sharedApplication ]setNetworkActivityIndicatorVisible:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
