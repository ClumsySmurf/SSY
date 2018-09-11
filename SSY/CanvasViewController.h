//
//  CanvasViewController.h
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "SavedViewController.h"
#import "FrameView.h"
#import "VideoPlayerViewController.h"
#import "SharePopover.h"
#import <Social/Social.h>
#import "SliderPopover.h"
#import "ASDepthModalViewController.h"
#import "PurchaseViewController.h"
#import "InfoViewController.h"
#import "PosesViewController.h"
#import "TutorialViewController.h"
#import "UIAlertController+MZStyle.h"

@interface CanvasViewController : GAITrackedViewController <UIActionSheetDelegate, UIPopoverControllerDelegate,
SharePopoverDelegate, SavedViewControllerDelegate, SliderPopoverDelegate,
FrameViewDelegate, PurchaseViewControllerDelegate, InfoViewControllerDelegate, PoseViewControllerDelegate>
{
    NSDictionary *ssyData;
    NSMutableArray *currentPoses;
   // NSMutableArray *timelinePoses;
    NSMutableArray *frameViews;
    NSMutableArray *timelineViews;
    
    
    SharePopover *popOver;
    FrameView *viewBeingDragged;
    SliderPopover *sliderPopover;
    float transistionDelay;
    PurchaseViewController *purchaseView;
    PosesViewController *poseView;
    
    NSTimer *scrollLeftTimer;
    NSTimer *scrollRightTimer;
    float scrollSpeed;
}


@property (weak, nonatomic) IBOutlet UIImageView *smallLogoView;
@property (nonatomic, strong) SavedViewController *m_savedViewController;
@property (strong, nonatomic) NSMutableArray  *timelinePoses;
@property (weak, nonatomic) IBOutlet UINavigationBar *m_navBar;
@property (weak, nonatomic) IBOutlet UISlider *m_timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *m_maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_minLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_sequenceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_totalPosesLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_ssyBttn;
@property (weak, nonatomic) IBOutlet UIImageView *m_tabBaseImageView;
@property (weak, nonatomic) IBOutlet UIButton *m_standingBttn;
@property (weak, nonatomic) IBOutlet UIButton *m_sittingBttn;
@property (weak, nonatomic) IBOutlet UIButton *m_floorBttn;
@property (weak, nonatomic) IBOutlet UIImageView *m_emptyImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *m_currentPosesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *m_timelineScrollView;
@property (weak, nonatomic) IBOutlet UIButton *m_clearBttn;
@property (weak, nonatomic) IBOutlet UIImageView *m_sliderShadow;

- (IBAction)ToggleSpeed:(UIButton *)sender;
- (IBAction)DelayChanged:(id)sender;
- (IBAction)ClearAction:(id)sender;
- (IBAction)SaveAction:(id)sender;
- (IBAction)PlayAction:(id)sender;
- (IBAction)ShareAction:(id)sender;
- (IBAction)togglePoses:(UIButton *)sender;
- (IBAction)InfoAction:(id)sender;
- (void)addSequence:(NSDictionary *)sequence;
@end
