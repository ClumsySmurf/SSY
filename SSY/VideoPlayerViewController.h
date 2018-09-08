//
//  VideoPlayerViewController.h
//  SSY
//
//  Created by John Hamilton on 1/20/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController : GAITrackedViewController
{
    MPMoviePlayerController *moviePlayer;
    int currentVideo;
}

@property (nonatomic, strong) NSArray *poses;
@property (nonatomic) float transistionDelay;
@property (weak, nonatomic) IBOutlet UIImageView *slideView;

@end
