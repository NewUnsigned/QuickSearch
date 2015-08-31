//
//  RTHXQuestionVC.m
//  RTHXiOSApp
//
//  Created by 融通汇信 on 15/8/25.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import "RTHXQuestionWebVC.h"

@interface RTHXQuestionWebVC ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation RTHXQuestionWebVC

- (void)viewDidLoad
{
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = self.view.bounds;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)viewDidLayoutSubviews
{
    self.webView.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.refreshBlock != nil) {
        self.refreshBlock();
    }
}

@end
