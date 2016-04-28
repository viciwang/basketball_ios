//
//  NewsRecourceViewController.m
//  MicroReader
//
//  Created by FreedomKing on 15/1/8.
//  Copyright (c) 2015年 RR. All rights reserved.
//

#import "NewsRecourceViewController.h"

@interface NewsRecourceViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsRecourceViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.webAddress) {
        NSURL *url = [NSURL URLWithString:self.webAddress];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        _progressView.hidden = NO;
        _progressView.progress = 0.3;
    }
    else {
        _progressView.hidden = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _progressView.progress = 1.0;
    [UIView animateWithDuration:0.2
                          delay:2.0
                        options:0 animations:^{
                            
                        }
                     completion:^(BOOL f){
                         _progressView.hidden = YES;
                     }];
}
- (void)dismissController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)returnButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
