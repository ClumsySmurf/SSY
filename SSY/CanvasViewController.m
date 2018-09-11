//
//  CanvasViewController.m
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "CanvasViewController.h"
#import "Apptentive.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface CanvasViewController ()

@end

@implementation CanvasViewController

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Canvas Screen";
 
    
    UIButton *savedBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize saveSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (CGSizeMake(29, 33)) : (CGSizeMake(25, 28));
    savedBttn.frame= CGRectMake(0, 0, saveSize.width, saveSize.height);
    [savedBttn setBackgroundImage:[UIImage imageNamed:@"savedBttn"] forState:UIControlStateNormal];
    [savedBttn addTarget:self action:@selector(showSavedSequences) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *savedItem = [[UIBarButtonItem alloc] initWithCustomView:savedBttn];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Sing Song Yoga"];
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    float fontSize = 12.f;
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (fontSize = 18.f) : (fontSize= 14.f);
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:fontSize];
    navLabel.text=@"Sing Song Yoga";
    navLabel.textAlignment = NSTextAlignmentCenter;
    item.titleView = navLabel;
    
    item.leftBarButtonItem = savedItem;
    
    [self.m_navBar pushNavigationItem:item animated:YES];
    
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.m_navBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[SavedViewController class]]) {
        
               
        self.m_savedViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"SavedView"];
        self.m_savedViewController.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
           
            self.slidingViewController.anchorRightRevealAmount=331;
            self.slidingViewController.anchorRightPeekAmount=700;
            self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
   
            self.m_savedViewController.view.frame = CGRectMake(0, 0, 331, 748);
            self.m_savedViewController.m_navBar.frame = CGRectMake(0, 0, 331, 33);

            
        }
        else
        {
            self.slidingViewController.anchorRightRevealAmount=180;
            //self.slidingViewController.anchorRightPeekAmount=390;
            self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
            
            self.m_savedViewController.view.frame = CGRectMake(0, 0, 200, 360);
            self.m_savedViewController.m_navBar.frame = CGRectMake(-50, 0, 200, 33);
        }
        
               self.slidingViewController.underLeftViewController  = self.m_savedViewController;

        }
    
    
    self.view.layer.shadowOpacity = 0.85f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //[self.m_timeSlider setThumbImage:[UIImage imageNamed:@"customThumb"] forState:UIControlStateNormal];
    
    [[UISlider appearanceWhenContainedIn:[self class], nil] setThumbImage:[UIImage imageNamed:@"customThumb"] forState:UIControlStateNormal];
    [[UISlider appearanceWhenContainedIn:[self class], nil] setMaximumTrackImage:
     [[UIImage imageNamed:@"sliderTrackImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,50, 0, 50)]
                                                                        forState:UIControlStateNormal];
    
    [[UISlider appearanceWhenContainedIn:[self class], nil] setMinimumTrackImage:
     [[UIImage imageNamed:@"sliderTrackImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50)]
                                                                        forState:UIControlStateNormal];
    
    
    
    float fsize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.f : 12.f;
    self.m_sequenceTimeLabel.font = [UIFont fontWithName:@"Bebas" size:fsize];
    self.m_totalPosesLabel.font = [UIFont fontWithName:@"Bebas" size:12.f];
    
    
    self.m_sequenceTimeLabel.textColor = self.m_totalPosesLabel.textColor = [UIColor colorWithRed:160/255.f green:156/255.f blue:151/255.f alpha:1];
    
    transistionDelay = 4;
    self.m_timeSlider.value = 4;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    [[Apptentive sharedConnection] engage:@"canvas_shown" fromViewController:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[Apptentive sharedConnection] engage:@"launch_survey" fromViewController:self];
        [[Apptentive sharedConnection] engage:@"show_ratings_prompt" fromViewController:self];
       
    });

    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TutShown"])
    {
        UIImageView *coach = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Coach"]];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:coach];
        coach.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //coach.center = self.view.center;
        coach.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coachTapped:)];
        [coach addGestureRecognizer:tap];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TutShown"];
    }


}

- (void)showSavedSequences
{
    if (self.slidingViewController.underLeftShowing)
    {
        
    }
    else
    [self.slidingViewController anchorTopViewTo:ECRight];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Fix our buttons
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (!IS_IPHONE_5)
        {
            
            self.m_standingBttn.transform = CGAffineTransformMakeTranslation(-88, 0);
            self.m_ssyBttn.transform = CGAffineTransformMakeTranslation(-88, 0);
            self.m_sittingBttn.transform = CGAffineTransformMakeTranslation(-88, 0);
            self.m_floorBttn.transform = CGAffineTransformMakeTranslation(-88, 0);
        }
    }

    currentPoses = [NSMutableArray array];
    timelinePoses = [NSMutableArray array];
    frameViews = [NSMutableArray array];
    timelineViews = [NSMutableArray array];
    ssyData = [SSY sequences];
    self.m_ssyBttn.enabled = YES;
    [self loadSSYPoses];
    [self reloadData];
   // self.m_currentPosesScrollView.clipsToBounds = NO;
    //self.m_timelineScrollView.clipsToBounds = NO;
    self.m_currentPosesScrollView.showsHorizontalScrollIndicator = NO;
    self.m_timelineScrollView.showsHorizontalScrollIndicator = NO;
    

    
    
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12.f : 8.f;
    self.m_standingBttn.titleLabel.font = self.m_sittingBttn.titleLabel.font =
    self.m_floorBttn.titleLabel.font = self.m_ssyBttn.titleLabel.font =
    [UIFont fontWithName:@"Bebas" size:fontSize];
    
       transistionDelay = 1.f;
    
    	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"kReloadNotification" object:nil];
}

- (void)coachTapped:(UITapGestureRecognizer*)sender {
    [sender.view removeFromSuperview];
}


- (void)showTutorial
{
    TutorialViewController *tutView = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        tutView.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:tutView animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ToggleSpeed:(UIButton *)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        sender.selected = !sender.selected;
    
        if (sender.selected == YES)
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.m_timeSlider.hidden = NO;
                self.m_maxLabel.alpha = 1;
                self.m_minLabel.alpha = 1;
                self.m_sliderShadow.alpha = 1;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.m_timeSlider.hidden = YES;
                self.m_maxLabel.alpha = 0;
                self.m_minLabel.alpha = 0;
                self.m_sliderShadow.alpha = 0;
            }];
        }
    }
    else
    {
        // Toggle our slider
        if (sliderPopover == nil)
        {
            sliderPopover = [[SliderPopover alloc] initFromPoint:CGPointMake(sender.frame.origin.x-154, sender.frame.origin.y-90)];
            [self.view addSubview:sliderPopover];
            sliderPopover.delegate = self;
            sliderPopover.m_slider.value = transistionDelay;
        }
        
        else
        {
            [self hideSliderPopover];
        }
    }
}


- (void)hideSliderPopover
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         sliderPopover.alpha = 0;
                     } completion:^(BOOL finished) {
                         [sliderPopover removeFromSuperview];
                         sliderPopover= nil;
                     }];
}

#pragma mark - iPhone slider delegate
- (void)sliderValueChanged:(float)value
{
    transistionDelay = value;
    [self updatePoseLabel];
}

#pragma mark - END

- (IBAction)DelayChanged:(id)sender {
    transistionDelay = self.m_timeSlider.value;
    [self updatePoseLabel];
}

- (IBAction)ClearAction:(id)sender {
    
    [WCAlertView setDefaultStyle:WCAlertViewStyleBlackHatched];
    
    [WCAlertView showAlertWithTitle:@"Clear Sequence Canvas" message:@"You are about to delete all of the poses from the Sequence Canvas."
                 customizationBlock:^(WCAlertView *alertView) {
        
      
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [timelinePoses removeAllObjects];
            [self reloadTimelineView];
            
            [UIView animateWithDuration:0.5f animations:^{
                self.m_clearBttn.hidden = YES;
                self.m_emptyImageView.hidden = NO;
                self.m_emptyImageView.alpha = 1;
            }];
        }
        
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear Canvas", nil];

}

- (IBAction)SaveAction:(id)sender {
    
    
    if ([timelinePoses count] < 1)
    {
        [self showAlertWithTitle:@"Error" andMsg:@"You need at least one pose in the Sequence Canvas in order to save a sequence"];
        return;
    }
    [WCAlertView setDefaultStyle:WCAlertViewStyleBlackHatched];
    
    [WCAlertView showAlertWithTitle:@"Save Your Sequence" message:@"Name your yoga sequence being saved" customizationBlock:^(WCAlertView *alertView) {
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            NSMutableDictionary *seq = [[NSMutableDictionary alloc] init];
            UITextField *field = [alertView textFieldAtIndex:0];
            [seq setObject:field.text forKey:@"Name"];
            
            NSMutableArray *poses = [[NSMutableArray alloc] init];
            
            for (NSDictionary *pose in timelinePoses)
            {
                [poses addObject:[pose objectForKey:@"Name"]];
            }
            
            [seq setObject:poses forKey:@"Poses"];
            [seq setObject:@"YES" forKey:@"Unlocked"];
            
            [SSY saveSequence:seq];
            
            
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
}


- (void)trackerSendCategory:(NSString*)cat action:(NSString*)action label:(NSString*)eventLabel andValue:(id)eventValue {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:cat     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:eventLabel         // Event label
                                                           value:eventValue] build]];    // Event value

}

- (IBAction)PlayAction:(id)sender {
    
    if (popOver != nil && popOver.isShown)
        [popOver hidePopover];
    
    if (sliderPopover != nil && sliderPopover.isShown)
        [self hideSliderPopover];
    
    if ([timelinePoses count] < 1)
    {
        [self showAlertWithTitle:@"Error" andMsg:@"There must be at least one pose on the Sequence Canvas to play."];
        return;
    }
    VideoPlayerViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoPlayer"];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [view setPoses:[NSArray arrayWithArray:timelinePoses]];
    view.transistionDelay = transistionDelay;
    [self presentViewController:view animated:YES completion:nil];
    

    
}
- (void)showAlertWithTitle:(NSString *)title andMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
message:msg delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}
- (IBAction)ShareAction:(id)sender {
    
    UIButton *bttn = (UIButton *)sender;
   /* UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", nil];
    
    
    [sheet showFromRect:bttn.frame inView:self.view animated:YES];*/
    if (!popOver.isShown)
    {
        popOver = [[SharePopover alloc] initFromPoint:CGPointMake(bttn.frame.origin.x-55, bttn.frame.origin.y-200)];
        popOver.delegate = self;
        [self.view addSubview:popOver];
    }
    else
    {
        [popOver hidePopover];
    }
}

#pragma mark - Popover delegates
- (void)facebookShareAction
{
    
    
    NSString *msg = [NSString stringWithFormat:@"We are doing a custom yoga sequence using the Sing Song Yoga™ %@ App. and are loving sharing this healthy time together! http://ow.ly/sIwes",
                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone"];
    
   if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
   {
       SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
       
       SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
           [controller dismissViewControllerAnimated:YES completion:Nil];
       };
       controller.completionHandler =myBlock;
       
       //Adding the Text to the facebook post value from iOS
       [controller setInitialText:msg];
       
       //Adding the URL to the facebook post value from iOS
       
       [controller addURL:[NSURL URLWithString:@"http://youtu.be/FqO7v2eUehs"]];
       
       //Adding the Image to the facebook post value from iOS
       
       //[controller addImage:[UIImage imageNamed:@"Mountain"]];
       
       [self presentViewController:controller animated:YES completion:Nil];
   }
    else
    {
        [self showAlertWithTitle:@"Error" andMsg:@"Please sign into Facebook on your device to allow sharing!"];
        return;
    }
}
- (void)twitterShareAction
{
    
    
    NSString *phoneShare = @"Doing the #SingSongYoga #kidsyoga #iPhone #app with the #kids and loving it!";
    NSString *tabletShare = @"Doing the #SingSongYoga #kidsyoga #iPad #app with the #kids and loving it!";
    
    NSString *msg = [NSString stringWithFormat:@"%@",
                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? tabletShare : phoneShare];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:msg];
        
        [controller addURL:[NSURL URLWithString:@"http://ow.ly/sIwes"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        [self showAlertWithTitle:@"Error" andMsg:@"Please sign into Twitter on your device to allow sharing!"];
        return;
    }
}

#pragma mark - Popover delegates END

- (IBAction)togglePoses:(UIButton *)sender {

    [purchaseView.view removeFromSuperview];
    purchaseView = nil;

    switch (sender.tag) {
        case 0:
            [self loadSSYPoses];
            break;
        case 1:
            [self loadStandingPoses];
            break;
        case 2: 
            [self loadSittingPoses];
            break;
        case 3:
            [self loadFloorPoses];
            break;
        default:
            [self loadSSYPoses];
            break;
    }
    
    [self.view bringSubviewToFront:self.m_navBar];
    
}

- (void)dismisPurchaseView
{
    [purchaseView dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)InfoAction:(id)sender {
    
    UINavigationController *infoView = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoView"];
    infoView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:infoView animated:YES completion:nil];
    ((InfoViewController *)infoView.topViewController).delegate = self;
}

- (void)restoredPurchases
{
    // Reload our items
    ssyData = [SSY sequences];
    
    if (!self.m_ssyBttn.enabled)
    {
        [self loadSSYPoses];
    }
    else if (!self.m_standingBttn.enabled)
    {
        [self loadStandingPoses];
    }
    else if (!self.m_sittingBttn.enabled)
    {
        [self loadSittingPoses];
    }
    else if (!self.m_floorBttn.enabled)
    {
        [self loadFloorPoses];
    }
    
    [self.view bringSubviewToFront:self.m_navBar];
}
- (void)loadSSYPoses
{
    self.m_ssyBttn.enabled = NO;
    self.m_standingBttn.enabled = YES;
    self.m_sittingBttn.enabled = YES;
    self.m_floorBttn.enabled = YES;
    // bring base to front then button
    [self.view bringSubviewToFront:self.m_tabBaseImageView];
    [self.m_tabBaseImageView setImage:[UIImage imageNamed:@"tabBase1"]];
    [self.view bringSubviewToFront:self.m_ssyBttn];
    
    
    NSArray *seq = [ssyData objectForKey:@"Sequences"];
    [self setupCanvasWithObjects:seq areSequences:YES];

}
- (void)loadStandingPoses
{
    self.m_ssyBttn.enabled = YES;
    self.m_standingBttn.enabled = NO;
    self.m_sittingBttn.enabled = YES;
    self.m_floorBttn.enabled = YES;
    // bring base to front then button
    [self.view bringSubviewToFront:self.m_tabBaseImageView];
    [self.m_tabBaseImageView setImage:[UIImage imageNamed:@"tabBase2"]];
    [self.view bringSubviewToFront:self.m_standingBttn];
    [self.view bringSubviewToFront:self.m_currentPosesScrollView];
    [self loadPosesForCategory:@"Standing"];
    
   
}
- (void)loadSittingPoses
{
    self.m_ssyBttn.enabled = YES;
    self.m_standingBttn.enabled = YES;
    self.m_sittingBttn.enabled = NO;
    self.m_floorBttn.enabled = YES;
    // bring base to front then button
    [self.view bringSubviewToFront:self.m_tabBaseImageView];
    [self.m_tabBaseImageView setImage:[UIImage imageNamed:@"tabBase3"]];
    [self.view bringSubviewToFront:self.m_sittingBttn];
    [self.view bringSubviewToFront:self.m_currentPosesScrollView];
    [self loadPosesForCategory:@"Sitting"];

}
- (void)loadFloorPoses
{
    self.m_ssyBttn.enabled = YES;
    self.m_standingBttn.enabled = YES;
    self.m_sittingBttn.enabled = YES;
    self.m_floorBttn.enabled = NO;
    // bring base to front then button
    [self.view bringSubviewToFront:self.m_tabBaseImageView];
    [self.m_tabBaseImageView setImage:[UIImage imageNamed:@"tabBase4"]];
    [self.view bringSubviewToFront:self.m_floorBttn];
    [self.view bringSubviewToFront:self.m_currentPosesScrollView];
    [self loadPosesForCategory:@"Floor"];

}
-(void)loadPosesForCategory:(NSString *)category
{
        
    NSArray *selectedPoses = [ssyData objectForKey:@"Poses"];
    
    NSMutableArray *poses = [NSMutableArray array];
    
    for (NSDictionary *pose in selectedPoses)
    {
        if ([[pose objectForKey:@"Category"] isEqualToString:category])
        {
            [poses addObject:pose];
        }
    }
    [self setupCanvasWithObjects:poses areSequences:NO];

}

- (void)savedSequenceTouched:(NSDictionary *)sequence
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.m_clearBttn.hidden = NO;
                         
                     }];
    
    self.m_emptyImageView.alpha = 0;
    NSArray *poses = [sequence objectForKey:@"Poses"];
    NSMutableArray *p = [SSY getPosesFromNames:poses];
    [timelinePoses addObjectsFromArray:p];
    [self reloadTimelineView];
    [self.slidingViewController resetTopView];
}


#define SPACING  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 189 : 300
- (void)setupCanvasWithObjects:(NSArray*)objects areSequences:(BOOL)sequences
{
    
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"Unlocked" ascending:NO];
    objects = [objects sortedArrayUsingDescriptors:@[sortDesc]];
    
    [self.view bringSubviewToFront:self.m_currentPosesScrollView];
    
    // Remove old views
    for (FrameView *view in frameViews)
    {
        view.delegate = nil;
        [view removeFromSuperview];
    }
    [frameViews removeAllObjects];
    
    float spacing = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 200 : 120;
    float topPadding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 35 : 0;
    float padding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 25 : 10;
    float totalWidth = 0;
    FrameType fType = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadCanvasFrame : kiPhoneCanvasFrame;
    

    for (int i = 0; i<[objects count]; i++)
    {
        if (!sequences)
        {
            FrameView *view = [[FrameView alloc] initWithFrameType:fType
                                                          itemType:kPoseFrame
                                                         andObject:[objects objectAtIndex:i]
                                                       andLocation:CGPointMake((spacing * i) + padding, topPadding)];
            view.delegate = self;
            totalWidth += view.frame.size.width;
            [self.m_currentPosesScrollView addSubview:view];
            [frameViews addObject:view];
            
            view.tag = i;
            NSDictionary *obj = [objects objectAtIndex:i];
            
            if ([[obj objectForKey:@"Unlocked"] boolValue] == YES)
            {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
                longPress.minimumPressDuration = 0.3;
            
                [view addGestureRecognizer:longPress];
            }
            
        }
        else
        {
            FrameView *view = [[FrameView alloc] initWithFrameType:fType
                                                          itemType:kSequenceFrame
                                                         andObject:[objects objectAtIndex:i]
                                                       andLocation:CGPointMake((spacing * i) + padding, topPadding)];
            view.tag = i;
            totalWidth += view.frame.size.width;
            view.delegate = self;
            [self.m_currentPosesScrollView addSubview:view];
            [frameViews addObject:view];
            NSDictionary *obj = [objects objectAtIndex:i];
            if ([[obj objectForKey:@"Unlocked"] boolValue] == YES)
            {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
                longPress.minimumPressDuration = 0.3;
                
                [view addGestureRecognizer:longPress];
            }

            
            //[view addGestureRecognizer:pan];
        }
    }
    
    [self.m_currentPosesScrollView setContentSize:CGSizeMake((spacing * [objects count]  + padding), self.m_currentPosesScrollView.contentSize.height)];
}
- (void)showPoses:(NSArray *)poses
{
    if (poseView != nil)
        return;
    
    poseView = [self.storyboard instantiateViewControllerWithIdentifier:@"PosesView"];
    poseView.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
    poseView.delegate = self;
    [self.view addSubview:poseView.view];
    [UIView animateWithDuration:0.4f
                     animations:^{
                         poseView.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [UIView animateWithDuration:0.3f
                                              animations:^{
                                                  poseView.m_bgView.alpha = 1;
                                                  [poseView loadPoses:poses];
                                }];
                         }
                     }];
    
    
}
- (void)poseViewDidClose
{
    poseView = nil;
}
#pragma mark - FrameView Delegate
- (void)showInAppPurchaseForItem:(id)frame
{
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"IAPNavigationController"];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
}
- (void)purchaseViewClosed
{
    
    
    purchaseView.delegate = nil;
    [purchaseView.view removeFromSuperview];
    purchaseView = nil;
    
}

- (void)reloadData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Reload our items
        ssyData = [SSY sequences];
        
        if (!ssyData) {
            [self reloadData];
        }
        
        if (!self.m_ssyBttn.enabled)
        {
            [self loadSSYPoses];
        }
        else if (!self.m_standingBttn.enabled)
        {
            [self loadStandingPoses];
        }
        else if (!self.m_sittingBttn.enabled)
        {
            [self loadSittingPoses];
        }
        else if (!self.m_floorBttn.enabled)
        {
            [self loadFloorPoses];
        }
        
        [self.view bringSubviewToFront:self.m_navBar];

    });
    
}
- (void)showAppPackages
{
    if (purchaseView != nil)
        return;
    
    purchaseView = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseView"];
    
    purchaseView.delegate = self;
    
    [self.view addSubview:purchaseView.view];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        purchaseView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    
    purchaseView.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
   
    [UIView animateWithDuration:0.4f
                     animations:^{
                         purchaseView.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [UIView animateWithDuration:0.3f
                                              animations:^{
                                                  purchaseView.m_bgView.alpha = 1;
                                                  
                                                  [purchaseView showPackages];
                                              }];
                         }
                     }];
    [self trackerSendCategory:@"Canvas Screen" action:@"Showing App Packages" label:@"Showing In App Purchases Packages" andValue:nil];
    

}
#pragma mark - Handle view panning
- (void)scrollLeft
{
    if (scrollSpeed > 190.f)
        scrollSpeed = 190.f;
    
    if (self.m_timelineScrollView.contentOffset.x > 0)
    {
        [self.m_timelineScrollView setContentOffset:CGPointMake(self.m_timelineScrollView.contentOffset.x -scrollSpeed, 0) animated:YES];
    }
    
    scrollSpeed += 15.f;

    
}
- (void)scrollRight
{
    if (scrollSpeed > 190.f)
        scrollSpeed = 190.f;

    
    if (self.m_timelineScrollView.contentOffset.x < (self.m_timelineScrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width))
    {
        [self.m_timelineScrollView setContentOffset:CGPointMake(self.m_timelineScrollView.contentOffset.x + scrollSpeed, 0) animated:YES];
    }
    
    scrollSpeed += 15.f;
}
- (void)handleDrag:(UILongPressGestureRecognizer *)gesture
{
    
    if (popOver != nil && popOver.isShown)
        [popOver hidePopover];
     CGPoint point = [gesture locationInView:self.view];
    
    
    BOOL intersects = CGRectIntersectsRect(viewBeingDragged.frame, self.m_timelineScrollView.frame);
    if (viewBeingDragged != nil)
    {
        if (point.x > (self.m_timelineScrollView.frame.size.width / 2) + 50 && intersects)
        {
            if (self.m_timelineScrollView.contentOffset.x < (self.m_timelineScrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width))
            {
                [scrollLeftTimer invalidate];
                if (![scrollRightTimer isValid])
                scrollRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollRight) userInfo:nil repeats:YES];
                
            }
        }
        else if (point.x < (self.m_timelineScrollView.frame.size.width / 2) - 50 && intersects)
        {
            if (self.m_timelineScrollView.contentOffset.x > 0)
            {
                [scrollRightTimer invalidate];
                if (![scrollLeftTimer isValid])
                scrollLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollLeft) userInfo:nil repeats:YES];
            }
        }
        else
        {
            scrollSpeed = 50;
            [scrollLeftTimer invalidate];
            [scrollRightTimer invalidate];
        }
    }
    
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            if (self.m_emptyImageView.alpha == 1)
            {
                [UIView animateWithDuration:0.5f
                                 animations:^{
                                     self.m_emptyImageView.alpha = 0;
                                     self.m_clearBttn.hidden = NO;
                                 }];
            }
            self.m_currentPosesScrollView.scrollEnabled = NO;
            self.m_timelineScrollView.scrollEnabled  = NO;
            
            if (viewBeingDragged == nil)
            {
                // Get our original frame view
                FrameView *callingView = (FrameView *)gesture.view;
                
                FrameType type;
                
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (type = kiPadTimelineFrame) : (type = kiPhoneTimelineFrame);
                
                viewBeingDragged = [[FrameView alloc] initWithFrameType:type
                                                               itemType:callingView.itemType andObject:callingView.data andLocation:point];
                viewBeingDragged.userInteractionEnabled = NO;
                viewBeingDragged.alpha = 0;
                viewBeingDragged.center = point;
                [self.view addSubview:viewBeingDragged];
                [UIView animateWithDuration:0.3f animations:^{
                    viewBeingDragged.alpha = 1;
                }];
            }
        }
        else if (gesture.state == UIGestureRecognizerStateChanged)
        {
            if (viewBeingDragged != nil)
            {
                viewBeingDragged.center = point;
            }
            
             
        }
        else if (gesture.state == UIGestureRecognizerStateEnded ||
                 gesture.state == UIGestureRecognizerStateCancelled)
    {
        scrollSpeed = 50.f;
        [scrollLeftTimer invalidate];
        [scrollRightTimer invalidate];
        
               if (viewBeingDragged != nil){
            
            BOOL intersects = CGRectIntersectsRect(viewBeingDragged.frame, self.m_timelineScrollView.frame);
            
            if (intersects)
            {
                if ([timelinePoses count] == 0)
                {
                    if (viewBeingDragged.itemType == kPoseFrame)
                    {
                        [timelinePoses addObject:viewBeingDragged.data]; // Just adds a pose to it
                        [self trackerSendCategory:@"Canvas Screen" action:@"Pose Dragged to Canvas" label:viewBeingDragged.data[@"Name"] andValue:viewBeingDragged.data];
                        [viewBeingDragged removeFromSuperview];
                        viewBeingDragged = nil;
                        [self reloadTimelineView];
                    }
                    else
                    {
                        NSMutableArray *poses = [SSY getPosesFromNames:
                                                 [viewBeingDragged.data objectForKey:@"Poses"]];
                          [self trackerSendCategory:@"Canvas Screen" action:@"Sequence Dragged to Canvas" label:viewBeingDragged.data[@"Name"] andValue:viewBeingDragged.data];
                        
                        [timelinePoses addObjectsFromArray:poses];
                        
                        [viewBeingDragged removeFromSuperview];
                        viewBeingDragged = nil;
                        [self reloadTimelineView];
                    }
                }
                else
                {
                    int locationToPlace =[timelineViews count];
                    // Determine where the drop should occur
                    for (int i = [timelineViews count]-1; i>-1; i--)
                    {
                        FrameView *frame = [timelineViews objectAtIndex:i];
                        CGPoint scrollPoint = [gesture locationInView:self.m_timelineScrollView];
                            
                        
                        // Check if frame is before me
                        float realDragX = (scrollPoint.x - (viewBeingDragged.frame.size.width / 2));
                        
                            if (realDragX < frame.frame.origin.x)
                            {
                                locationToPlace = frame.tag;
                            }
                        
                    }
                    
                    if (viewBeingDragged.itemType == kPoseFrame)
                    {
                        
                        [timelinePoses insertObject:viewBeingDragged.data atIndex:locationToPlace];
                          [self trackerSendCategory:@"Canvas Screen" action:@"Pose Dragged to Canvas"
                                              label:viewBeingDragged.data[@"Name"] andValue:viewBeingDragged.data];
                    }
                    else
                    {
                        NSMutableArray *poses = [SSY getPosesFromNames:
                                                 [viewBeingDragged.data objectForKey:@"Poses"]];
                        
                          [self trackerSendCategory:@"Canvas Screen" action:@"Sequence Dragged to Canvas" label:viewBeingDragged.data[@"Name"] andValue:viewBeingDragged.data];
                        
                        
                        int count = [poses count];
                        int counter = 0;
                        for (int i = locationToPlace; i<(locationToPlace + count); i++)
                        {
                            [timelinePoses insertObject:[poses objectAtIndex:counter] atIndex:i];
                            counter++;
                        }

                    }
                    [viewBeingDragged removeFromSuperview];
                    viewBeingDragged = nil;
                    [self reloadTimelineView];
                }
            }
            else {
            [viewBeingDragged removeFromSuperview];
            viewBeingDragged = nil;
            }
        }
        self.m_timelineScrollView.scrollEnabled = YES;
        self.m_currentPosesScrollView.scrollEnabled = YES;
     
        if (self.m_emptyImageView.alpha == 0 && [timelinePoses count] == 0)
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.m_emptyImageView.alpha = 1;
                self.m_clearBttn.hidden = YES;
                //self.m_
            }];
        }

            
        

        
    }
}

- (void)reloadTimelineView
{
    if (popOver != nil && popOver.isShown)
        [popOver hidePopover];
    [self.view bringSubviewToFront:self.m_currentPosesScrollView];
    
    // Remove old views
    for (UIView *view in [self.m_timelineScrollView subviews])
    {
        [view removeFromSuperview];
    }
   
    [timelineViews removeAllObjects];
    
    float spacing = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 255 : 145;
    float topPadding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 5 : 0;
    float padding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 10;
    float plusImagePadding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10 : 5;
    float totalWidth = 0;
    CGSize starSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(11, 12) : CGSizeMake(7, 8);
    
    FrameType fType = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadTimelineFrame : kiPhoneTimelineFrame;
    
    
    for (int i = 0; i<[timelinePoses count]; i++)
    {
       
            FrameView *view = [[FrameView alloc] initWithFrameType:fType itemType:kPoseFrame andObject:[timelinePoses objectAtIndex:i]
                                                       andLocation:CGPointMake((spacing * i) + padding, topPadding)];
            view.tag = i;
            totalWidth += view.frame.size.width;
            [self.m_timelineScrollView addSubview:view];
            [timelineViews addObject:view];
        
            if (i > 0 && i<[timelinePoses count])
            {
                UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusShape"]];
                star.frame = CGRectMake((spacing * i) + plusImagePadding,
                                        self.m_timelineScrollView.frame.size.height / 2 - 5, starSize.width, starSize.height);
                [self.m_timelineScrollView addSubview:star];
            }
            
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimelineDrag:)];
            longPress.minimumPressDuration = 0.5;
            
            [view addGestureRecognizer:longPress];
            
           }
    
    [self.m_timelineScrollView setContentSize:CGSizeMake((spacing * ([timelinePoses count]) + padding), self.m_currentPosesScrollView.contentSize.height)];
    
    self.m_timelineScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 80);
    self.m_timelineScrollView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self updatePoseLabel];
    
    if ([timelinePoses count] == 0)
    {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.m_clearBttn.hidden = YES;
                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                             {
                                 self.m_sequenceTimeLabel.alpha = 0;
                                 self.smallLogoView.hidden = YES;
                             }
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.5f
                         animations:^{
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            {
                                 self.m_sequenceTimeLabel.alpha = 1;
                                self.smallLogoView.hidden = NO;
                            }
                         }];

    }
}

- (void)handleTimelineDrag:(UILongPressGestureRecognizer *)gesture
{
    if (popOver != nil && popOver.isShown)
        [popOver hidePopover];
    CGPoint point = [gesture locationInView:self.view];
    
    
    BOOL intersects = CGRectIntersectsRect(viewBeingDragged.frame, self.m_timelineScrollView.frame);
    if (viewBeingDragged != nil)
    {
        if (point.x > (self.m_timelineScrollView.frame.size.width / 2) + 50 && intersects)
        {
            if (self.m_timelineScrollView.contentOffset.x < (self.m_timelineScrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width))
            {
                [scrollLeftTimer invalidate];
                if (![scrollRightTimer isValid])
                    scrollRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollRight) userInfo:nil repeats:YES];
                
            }
        }
        else if (point.x < (self.m_timelineScrollView.frame.size.width / 2) - 50 && intersects)
        {
            if (self.m_timelineScrollView.contentOffset.x > 0)
            {
                [scrollRightTimer invalidate];
                if (![scrollLeftTimer isValid])
                    scrollLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollLeft) userInfo:nil repeats:YES];
            }
        }
        else
        {
            scrollSpeed = 50;
            [scrollLeftTimer invalidate];
            [scrollRightTimer invalidate];
        }
    }

    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        if (self.m_emptyImageView.alpha == 1)
        {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 self.m_emptyImageView.alpha = 0;
                             }];
        }
        self.m_currentPosesScrollView.scrollEnabled = NO;
        self.m_timelineScrollView.scrollEnabled  = NO;
        
        if (viewBeingDragged == nil)
        {
            // Get our original frame view
            
            FrameView *callingView = (FrameView *)gesture.view;
            [timelineViews removeObjectAtIndex:callingView.tag];
            [timelinePoses removeObjectAtIndex:callingView.tag];
            FrameType type;
            
            [self trackerSendCategory:@"Canvas Screen" action:@"Dragging Pose In Timeline" label:callingView.data[@"Name"] andValue:nil];
            
            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (type = kiPadTimelineFrame) : (type = kiPhoneTimelineFrame);
            
            callingView.alpha = 0;
            viewBeingDragged = [[FrameView alloc] initWithFrameType:type
                                                           itemType:callingView.itemType andObject:callingView.data andLocation:point];
            viewBeingDragged.userInteractionEnabled = NO;
            viewBeingDragged.alpha = 0;
            viewBeingDragged.center = point;
            [self.view addSubview:viewBeingDragged];
            [UIView animateWithDuration:0.3f animations:^{
                viewBeingDragged.alpha = 1;
            }];
            
        }
       }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        if (viewBeingDragged != nil)
        {
            viewBeingDragged.center = point;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled)
    {
        
        scrollSpeed = 50;
        [scrollLeftTimer invalidate];
        [scrollRightTimer invalidate];

        [gesture.view removeFromSuperview];
        
        if (viewBeingDragged != nil){
            
            BOOL intersects = CGRectIntersectsRect(viewBeingDragged.frame, self.m_timelineScrollView.frame);
            
            if (intersects)
            {
                if ([timelinePoses count] == 0)
                {
                    if (viewBeingDragged.itemType == kPoseFrame)
                    {
                        [timelinePoses addObject:viewBeingDragged.data]; // Just adds a pose to it
                        [viewBeingDragged removeFromSuperview];
                        viewBeingDragged = nil;
                        [self reloadTimelineView];
                    }
                    else
                    {
                        NSMutableArray *poses = [SSY getPosesFromNames:
                                                 [viewBeingDragged.data objectForKey:@"Poses"]];
                        
                        [timelinePoses addObjectsFromArray:poses];
                        
                        [viewBeingDragged removeFromSuperview];
                        viewBeingDragged = nil;
                        [self reloadTimelineView];
                    }
                }
                else
                {
                    int locationToPlace =[timelineViews count];
                    // Determine where the drop should occur
                    for (int i = [timelineViews count]-1; i>-1; i--)
                    {
                        FrameView *frame = [timelineViews objectAtIndex:i];

                        CGPoint scrollPoint = [gesture locationInView:self.m_timelineScrollView];
                        
                        
                        // Check if frame is before me
                        float realDragX = (scrollPoint.x - (viewBeingDragged.frame.size.width / 2));
                        
                        if (realDragX < frame.frame.origin.x)
                        {
                            locationToPlace = frame.tag;
                        }
                        
                    }
                    
                    if (viewBeingDragged.itemType == kPoseFrame)
                    {
                        
                        [timelinePoses insertObject:viewBeingDragged.data atIndex:locationToPlace];
                    }
                    else
                    {
                        NSMutableArray *poses = [SSY getPosesFromNames:
                                                 [viewBeingDragged.data objectForKey:@"Poses"]];
                        
                        
                        
                        int count = [poses count];
                        int counter = 0;
                        for (int i = locationToPlace; i<(locationToPlace + count); i++)
                        {
                            [timelinePoses insertObject:[poses objectAtIndex:counter] atIndex:i];
                            counter++;
                        }
                        
                    }
                    [viewBeingDragged removeFromSuperview];
                    viewBeingDragged = nil;
                    [self reloadTimelineView];
                }
            }
            else {
                [self reloadTimelineView];
                [viewBeingDragged removeFromSuperview];
                viewBeingDragged = nil;
            }
        }
        self.m_timelineScrollView.scrollEnabled = YES;
        self.m_currentPosesScrollView.scrollEnabled = YES;
        
        if (self.m_emptyImageView.alpha == 0 && [timelinePoses count] == 0)
        {
            [UIView animateWithDuration:0.5f animations:^{
                self.m_emptyImageView.alpha = 1;
            }];
        }
        
        
    }
}

- (void)updatePoseLabel
{
    self.m_totalPosesLabel.text = [NSString stringWithFormat:@"TOTAL POSES - %d", [timelinePoses count]];
    
    float totalTime = 0;
    
     
    for (NSDictionary *pose in timelinePoses)
    {
        totalTime += [[pose objectForKey:@"Length"] floatValue];
    }

    if ([timelinePoses count] > 1)
    {
        totalTime += ([timelinePoses count]-1) * transistionDelay;
    }
    if (timelinePoses.count > 0)
        totalTime += 4;
    
    
    
    int hours, minutes, seconds;
    seconds =totalTime;
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
   
    
    
    
    if (hours > 0)
    self.m_sequenceTimeLabel.text = [NSString stringWithFormat:@"TOTAL SEQUENCE TIME - %02d:%02d:%02d", hours,minutes, seconds];
    else
        self.m_sequenceTimeLabel.text = [NSString stringWithFormat:@"TOTAL SEQUENCE TIME - %d:%02d", minutes,seconds];
    
}

@end
