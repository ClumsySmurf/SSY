//
//  GuidelineViewController.h
//  SSY
//
//  Created by John Hamilton on 1/25/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GuidelineViewController : GAITrackedViewController <UIWebViewDelegate>
{
     MPMoviePlayerController *moviePlayer;
}
@property (weak, nonatomic) IBOutlet UIWebView *m_guidelineView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_activityView;

@end
