//
//  ViewController.m
//  JSAndOCInteractionUIWebViewDemo
//
//  Created by KODIE on 2018/1/15.
//  Copyright © 2018年 kodie. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UIWebViewDelegate>

@property(nonatomic, weak) UIWebView *webView;
@property(nonatomic, strong) JSContext *webJSContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configWebView];
}

- (void)configWebView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    NSURL *url = [NSURL URLWithString:@"https://m.benlai.com/huanan/zt/1231cherry"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    webView.delegate = self;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //取出html中的js执行环境  固定写法
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //实现html中jsBack函数(给其传入一个block)  js->oc
    jsContext[@"addProductToCartWithMove"] = ^(NSInteger brandID, NSInteger success, NSInteger error) {
        NSLog(@"%zd",brandID);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMsg:[NSString stringWithFormat:@"产品ID:%zd",brandID]];
        });
    };
    self.webJSContext = jsContext;
}

#pragma mark - private
- (void)showMsg:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

@end
