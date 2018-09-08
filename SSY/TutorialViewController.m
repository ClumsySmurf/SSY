//
//  TutorialViewController.m
//  SSY
//
//  Created by John Hamilton on 4/4/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "TutorialViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TutorialViewController ()
{
    NSMutableArray *tutImages;
    int currentPage;
    NSMutableArray *tutText;
}

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      self.screenName = @"Tutorial Screen";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupScrollView];
}
- (void)viewDidLoad
{
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.navBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    UIButton *closeBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBttn.frame= CGRectMake(0, 0, 49, 25);
    [closeBttn setBackgroundImage:[UIImage imageNamed:@"navEditBttn"] forState:UIControlStateNormal];
    [closeBttn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBttn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBttn];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Information"];
    
    UIFont *font = [UIFont fontWithName:@"Bebas" size:12.f];
    closeBttn.titleLabel.font = font;
    closeBttn.titleLabel.textColor = [UIColor colorWithRed:86/255.f green:77/255.f
                                                      blue:67/255.f alpha:1];
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    float navSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.f : 12.f;
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:navSize];
    navLabel.text=@"Sing Song Yoga - Tutorial";
    navLabel.textAlignment = NSTextAlignmentCenter;
    item.titleView = navLabel;
    
    item.leftBarButtonItem = closeItem;
    [self.navBar pushNavigationItem:item animated:YES];

    
    tutText = [NSMutableArray array];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [tutText addObject:@"From the Pose Tabs press, hold, and drag Poses to the Sequence Canvas. Notice the color coding of the Poses: Blue = calming, Red = energizing, Yellow = neutral."];
        [tutText addObject:@"Move Poses around within the Sequence Canvas or drop a pose back into the tabs area. Notice the time and poses accumulate."];
        [tutText addObject:@"Default speed for Transition Slides is 4 seconds..."];
        [tutText addObject:@"...or customize your Transition speed using the Speed Button and Slider. First Transition Slide remains 4 seconds."];
        [tutText addObject:@"Tap Play..."];
        [tutText addObject:@"...and your yoga video begins"];
        [tutText addObject:@"You may wish to Save your Sequence. Tap Save..."];
        [tutText addObject:@"...and name your Sequence"];
        [tutText addObject:@"Your Saved Sequences are found behind the Main Screen by tapping the Saved button"];
        [tutText addObject:@"Clear the Sequence Canvas by tapping the paint brush"];
        [tutText addObject:@"To use a PreProgrammed Sing Song Yoga™ Sequence, under SSY Sequence Tab tap a Sequence to see its poses"];
        [tutText addObject:@"Press, hold, and drag a SSY Sequence to the Sequence Canvas"];
        [tutText addObject:@"Poses in that SSY Sequence display in the Canvas. Move, add, delete Poses. Change your Speed. Save and name. Play and clear."];
        [tutText addObject:@"Share your fun!"];
        [tutText addObject:@"Purchase Sequence Packages, Poses or SSY Sequences (long or short) by either tapping on a locked Pose or Sequence, or swipe through the In-App Purchase Packages under the Info. Button"];
         
    }
    else
    {
        [tutText addObject:@"From the Pose Tabs press, hold, and drag Poses to the Sequence Canvas. Notice the color coding of the Poses: Blue = calming, Red = energizing, Yellow = neutral."];
        [tutText addObject:@"Move Poses around within the Sequence Canvas or drop a pose back into the tabs area. Notice the time accumulate."];
        [tutText addObject:@"Default speed for Transition Slides is 4 seconds..."];
        [tutText addObject:@"...or customize your Transition speed using the Speed Button and Slider. First Transition Slide remains 4 seconds."];
        [tutText addObject:@"Tap Play..."];
        [tutText addObject:@"...and your yoga video begins"];
        [tutText addObject:@"You may wish to Save your Sequence. Tap Save..."];
        [tutText addObject:@"...and name your Sequence"];
        [tutText addObject:@"Your Saved Sequences are found behind the Main Screen by tapping the Saved button"];
        [tutText addObject:@"Clear the Sequence Canvas by tapping the paint brush"];
        [tutText addObject:@"To use a PreProgrammed Sing Song Yoga™ Sequence, under SSY Sequence Tab tap a Sequence to see its poses"];
        [tutText addObject:@"... and the Poses within that Sequence pop up"];
        [tutText addObject:@"Press, hold, and drag a SSY Sequence to the Sequence Canvas"];
        [tutText addObject:@"Poses in that SSY Sequence display in the Canvas. Move, add, delete Poses. Change your Speed. Save and name. Play and clear."];
        [tutText addObject:@"Share your fun!"];
        [tutText addObject:@"Purchase Sequence Packages, Poses or SSY Sequences (long or short) by either tapping on a locked Pose or Sequence, or swipe through the In-App Purchase Packages under the Info. Button"];
        
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setupScrollView
{
    int max = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 16 : 17;
    float pageWidth = self.scrollView.frame.size.width;
    float pageHeight = self.scrollView.frame.size.height;
    self.scrollView.pagingEnabled = YES;
    
    NSLog(@"Frame is %2f", self.scrollView.frame.size.width);
    
    for (int i = 1; i<max; i++)
    {
        // Set up all our images;
        float minus = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100 : 50;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*pageWidth,
                                                                               0, pageWidth,
                                                                                pageHeight-minus)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
        [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imageView.layer setBorderWidth:2.0f];
        [self.scrollView addSubview:imageView];
    }
    
    // add the guidelines video
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *moviePath = [bundle pathForResource:@"Guidelines" ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.view.userInteractionEnabled = YES;
    moviePlayer.shouldAutoplay = NO;
    [moviePlayer prepareToPlay];
    
    float offset =(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 200 : 90;
    float gvOffset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : 0;
    CGRect frame = CGRectMake(pageWidth * (max-1), 0-gvOffset, pageWidth, pageHeight-offset);
    moviePlayer.view.frame = frame;
    
    float webHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 150 : 75;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.size.height-gvOffset, frame.size.width, webHeight)];
    [self.scrollView addSubview:webView];
    [self.scrollView addSubview:moviePlayer.view];

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Guidelines" ofType:@"htm"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.backgroundColor = [UIColor blackColor];
    webView.opaque = NO;
    webView.scrollView.backgroundColor = [UIColor blackColor];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * (max + 1), self.scrollView.frame.size.height)];
    self.pageControl.numberOfPages = max + 1;
    
    //Logo page
    float logo_offset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : 40;
    float xoffset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 30 : 0;
    CGSize logoSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? (CGSize){pageWidth,300} : (CGSize){pageWidth,200};
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((pageWidth * max),
                                                                      ((logoSize.height/2)/2) - logo_offset, logoSize.width, logoSize.height)];
    [logo setImage:[UIImage imageNamed:@"iTunesArtwork1024"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.opaque = YES;
    
    self.scrollView.clipsToBounds = NO;
    
    [self.scrollView addSubview:logo];
    
    [self scrollViewDidScroll:self.scrollView];
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentPage;
    
    [self.activityIndicator setHidden:YES];
    
    if (currentPage < [tutText count])
    {
        self.infoLabel.text = [tutText objectAtIndex:currentPage];
    }
    else if ((currentPage+1) == self.pageControl.numberOfPages)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.infoLabel.text = @"Thank you for choosing our Sing Song Yoga™ iPad App. We trust you will love it as we do!";
        }
        else
        {
            self.infoLabel.text = @"Thank you for choosing our Sing Song Yoga™ iPhone App. We trust you will love it as we do!";
        }
    }
    else{
        self.infoLabel.text = @"";
       
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
