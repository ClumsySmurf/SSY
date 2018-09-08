//
//  WebViewController.m
//  SSY
//
//  Created by John Hamilton on 1/24/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    UIButton *backBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBttn.frame= CGRectMake(0, 0, 64, 26);
    [backBttn setBackgroundImage:[UIImage imageNamed:@"navBackBttn"] forState:UIControlStateNormal];
    [backBttn setTitle:@"  Back" forState:UIControlStateNormal];
    [backBttn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBttn];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Information"];
    
    UIFont *font = [UIFont fontWithName:@"Bebas" size:12.f];
    backBttn.titleLabel.font = font;
    backBttn.titleLabel.textColor = [UIColor colorWithRed:86/255.f green:77/255.f
                                                      blue:67/255.f alpha:1];
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    float navSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.f : 12.f;
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:navSize];
    navLabel.text=@"Sing Song Yoga";
    navLabel.textAlignment = NSTextAlignmentCenter;
    item.titleView = navLabel;
    
    item.leftBarButtonItem = backItem;
    // [self.navigationController.navigationBar pushNavigationItem:item animated:YES];
    // [self.m_navBar pushNavigationItem:item animated:YES];
    
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.titleView = navLabel;
    
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.navigationController.navigationBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _m_webView.delegate = self;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webview failed to load: %@", error.localizedDescription);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.m_activityIndicator stopAnimating];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.m_activityIndicator startAnimating];
}
- (void)handleBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"loading request");
    return YES;
}

- (void)showAboutUs
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Program" ofType:@"html" inDirectory:nil];
        NSError *error = nil;
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:&error];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSLog(@"error: %@ : %@", error.localizedDescription, error.localizedRecoverySuggestion);
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [_m_webView loadHTMLString:htmlString baseURL:baseURL];
    });
    

}
- (void)showSequences
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SSY Sequences" ofType:@"htm"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)showPurchaseDVD
{
    NSURL *url = [NSURL URLWithString:@"http://www.singsongyoga.com/childrens-yoga-dvd/"];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)showDisclaimer
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"htm"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)showGlossery
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Glossery" ofType:@"htm"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];

}
- (void)showCopyright
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"copyright" ofType:@"html"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)loadRequest:(NSURLRequest *)request {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.m_webView loadRequest:request];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
