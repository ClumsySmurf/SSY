//
//  TutorialViewController.h
//  SSY
//
//  Created by John Hamilton on 4/4/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuidelineViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TutorialViewController : GAITrackedViewController <UIScrollViewDelegate>
{
    MPMoviePlayerController *moviePlayer;
    UIWebView *webView;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
