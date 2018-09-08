//
//  GuidelineViewController.m
//  SSY
//
//  Created by John Hamilton on 1/25/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "GuidelineViewController.h"

@interface GuidelineViewController ()

@end

@implementation GuidelineViewController

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
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:18.f];
    navLabel.text=@"Guidelines Video";
    navLabel.textAlignment = NSTextAlignmentCenter;

    
    item.leftBarButtonItem = backItem;
    // [self.navigationController.navigationBar pushNavigationItem:item animated:YES];
    // [self.m_navBar pushNavigationItem:item animated:YES];
    
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.titleView = navLabel;
    
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.navigationController.navigationBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)handleBack
{
    [moviePlayer stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *moviePath = [bundle pathForResource:@"Guidelines" ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    // moviePlayer.con
    moviePlayer.view.userInteractionEnabled = YES;
    moviePlayer.shouldAutoplay = NO;
    
    //Place it in subview, else it won’t work
    
    

    CGRect frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = CGRectMake(0, -25, 540, 350)) :
    (frame = CGRectMake(0, 0, frame.size.height, 190));
    moviePlayer.view.frame = frame;
    [self.view addSubview:moviePlayer.view];

    [moviePlayer play];
    

    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Guidelines" ofType:@"htm"]];
    [self.m_guidelineView loadRequest:[NSURLRequest requestWithURL:url]];
    
   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.m_activityView stopAnimating];
    self.m_guidelineView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.m_guidelineView.scrollView flashScrollIndicators];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
