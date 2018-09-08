//
//  VideoPlayerViewController.m
//  SSY
//
//  Created by John Hamilton on 1/20/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    currentVideo = 0;
   
    [self loadCurrentMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)doneButtonClick:(id)sender
{
    
    if (currentVideo < self.poses.count) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Player"     // Event category (required)
                                                              action:@"Done Showing Before Completion"  // Event action (required)
                                                               label:[self namesOfPoses]         // Event label
                                                               value:nil ]build]];    // Event value

        
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Player"     // Event category (required)
                                                              action:@"Done Showing After Completion"  // Event action (required)
                                                               label:[self namesOfPoses]         // Event label
                                                               value:nil]build]];    // Event value
        

    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadCurrentMovie
{
    
    if (self.transistionDelay == 0)
        self.transistionDelay = 1;
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    if (currentVideo >= [self.poses count])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    NSDictionary *pose = [self.poses objectAtIndex:currentVideo];
    NSString *moviePath = [bundle pathForResource:[pose objectForKey:@"Video"] ofType:@"m4v"];
    
    [self.slideView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ Slide", [pose objectForKey:@"Image"]]]];
    self.slideView.alpha = 0;
       
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    //moviePlayer.movieControlMode = MPMovieControlModeHidden;
    // moviePlayer.con
    moviePlayer.view.userInteractionEnabled = NO;
    moviePlayer.shouldAutoplay = NO;
    moviePlayer.view.alpha = 0;

    
    //Place it in subview, else it won’t work
    
    CGRect frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = CGRectMake(0, 0, 1024, 758)) : (frame = CGRectMake(0, 0, frame.size.height, frame.size.width));
    moviePlayer.view.frame = frame;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         moviePlayer.view.alpha = 0;
                         [self.view sendSubviewToBack:moviePlayer.view];
                         self.slideView.hidden = NO;
                         self.slideView.alpha = 1;
                     }];
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    //Resize window – a bit more practical
    // Play the movie.
    //[moviePlayer play];
    [moviePlayer setCurrentPlaybackTime:0.7];
  //  [NSTimer scheduledTimerWithTimeInterval:0.7f target:moviePlayer selector:@selector(pause) userInfo:nil repeats:NO];
    
    NSLog(@"Delay is %2f", self.transistionDelay);
    if (currentVideo > 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:self.transistionDelay target:self selector:@selector(playVideo) userInfo:nil repeats:NO];
    }
    else if (currentVideo == 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(playVideo) userInfo:nil repeats:NO];
    }
    currentVideo++;
}

- (void)playVideo
{

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    [UIView animateWithDuration:1.5f
                     animations:^{
                         self.slideView.alpha = 0;
                         moviePlayer.view.alpha = 1;
                       

                        
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [self.view sendSubviewToBack:self.slideView];
                             [moviePlayer play];
                             //moviePlayer.movieControlMode = MPMovieControlModeDefault;
                             moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
                         }
                     }];
    
    //[moviePlayer play];
    moviePlayer.view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        //movie finished playing
        NSLog(@"Movie play did finish");
        [moviePlayer.view removeFromSuperview];
        moviePlayer = nil;
        [self loadCurrentMovie];
    }
    else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
        MPMoviePlayerController *moviePlayer = [notification object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        if (currentVideo < self.poses.count) {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Player"     // Event category (required)
                                                                  action:@"Done Showing Before Completion"  // Event action (required)
                                                                   label:[self namesOfPoses]         // Event label
                                                                   value:nil]build]];    // Event value
            
            
        } else {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Player"     // Event category (required)
                                                                  action:@"Done Showing After Completion"  // Event action (required)
                                                                   label:[self namesOfPoses]         // Event label
                                                                   value:nil]build]];    // Event value
            
            
        }

        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString*)namesOfPoses {
    NSMutableString *poses = [NSMutableString new];
    
    for (NSDictionary *pose in self.poses) {
        [poses appendString:[NSString stringWithFormat:@"%@ ", pose[@"Name"]]];
    }
    return poses;
}

@end
