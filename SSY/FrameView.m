//
//  FrameView.m
//  SSY
//
//  Created by John Hamilton on 1/18/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "FrameView.h"


@interface FrameView()
{
    BOOL isFlipping;
}
@end

@implementation FrameView

#define iPadTimelineSize CGSizeMake(243,171)
#define iPadCanvasSize CGSizeMake(189,135)
#define iPadCanvasPictureFrame CGRectMake(9,10,170,95)
#define iPadTimelinePictureFrame CGRectMake(10,10,220,124)
#define iPhoneCanvasSize CGSizeMake(114,83)
#define iPhoneCanvasPictureFrame CGRectMake(8,7,98,55.5)
#define iPhoneTimelineSize CGSizeMake(142,101)
#define iPhoneTimelinePictureFrame CGRectMake(8,7,125,70)
#define iPhoneInAppPictureFrame CGRectMake(13,12,195,99)


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrameType:(FrameType)frameType itemType:(ItemType)type andObject:(NSDictionary *)object andLocation:(CGPoint)location
{
    

    switch (frameType) {
        case kiPadTimelineFrame:
            self = [super initWithFrame:CGRectMake(location.x, location.y, iPadTimelineSize.width, iPadTimelineSize.height)];
            self.data = object;
            break;
        case kiPadCanvasFrame:
            self = [super initWithFrame:CGRectMake(location.x, location.y, iPadCanvasSize.width, iPadCanvasSize.height)];
            self.data = object;
            break;
        case kiPhoneCanvasFrame:
            self = [super initWithFrame:CGRectMake(location.x, location.y, iPhoneCanvasSize.width, iPhoneCanvasSize.height)];
            self.data = object;
            break;
        case kiPhoneTimelineFrame:
            self = [super initWithFrame:CGRectMake(location.x, location.y, iPhoneTimelineSize.width, iPhoneTimelineSize.height)];
            self.data = object;
            break;
            
        default:
            self = [super initWithFrame:CGRectMake(location.x, location.y,
                                                   100, 100)];
            break;
    }
    
    
    self.frameType = frameType;
    self.itemType = type;
    
    if (frameType == kiPadCanvasFrame || frameType == kiPhoneCanvasFrame)
    {
        [self setupCanvasFrame];
    }
    else if (frameType == kiPhoneTimelineFrame || frameType == kiPadTimelineFrame)
    {
        [self setupTimelineFrame];
    }
    
    
    
    return self;
}


- (id)initWithFrameType:(FrameType)frameType
               itemType:(ItemType)type andObject:(NSDictionary *)object andFrame:(CGRect)frame
{
    
    if ( (self = [super initWithFrame:frame]))
    {
        self.data = object;
    
        self.frameType = frameType;
        self.itemType = type;
    
        switch (frameType) {
            case kInAppPoseFrame:
                [self setupInAppPoseFrame];
                break;
            case kInAppSequenceFrame:
                [self setupInAppSequenceFrame];
                break;
            case kInAppPackageFrame:
                [self setupPackageFrame];
                break;
            default:
                break;
        }
           
    }
    
    return self;
}

- (void)setupPackageFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"graySmallFrame"]];
    [self addSubview:bg];
    
    CGRect nameFrame =  CGRectMake(0, self.frame.size.height-33, self.frame.size.width, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.f : 10.f;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
     if ([[self.data objectForKey:@"Everything"] boolValue] == YES)
         nameLabel.text = @"Opens everything up";
    else
        nameLabel.text = @"Tap to see included Sequences";
    
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    // Setup image view
    CGRect frame= iPhoneInAppPictureFrame;
    UIImage *image = [UIImage imageNamed:[self.data objectForKey:@"Image"]];
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:image];
    [self addSubview:centerView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self addGestureRecognizer:tap];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self viewTapped];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self viewTapped];
        });
    });
    

}
- (void)setupInAppSequenceFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"graySmallFrame"]];
    [self addSubview:bg];
    
    
    CGRect nameFrame =  CGRectMake(0, self.frame.size.height-33, self.frame.size.width, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 14.f : 10.f;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"Tap to see included poses";
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    // Setup image view
    CGRect frame;
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPhoneInAppPictureFrame) : (frame = iPhoneInAppPictureFrame);
    NSArray *poses = [self.data objectForKey:@"Poses"];
    UIImage *image = [SSY getImageForPose:[poses objectAtIndex:0]];
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:image];
    [self addSubview:centerView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self addGestureRecognizer:tap];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self viewTapped];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self viewTapped];
        });
    });
    
    

}
- (void)setupInAppPoseFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    // Get the cooling color
    if ([[self.data objectForKey:@"Effect"] isEqualToString:@"E"])
        [bg setImage:[UIImage imageNamed:@"redBigFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"C"])
        [bg setImage:[UIImage imageNamed:@"blueBigFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"N"])
        [bg setImage:[UIImage imageNamed:@"yellowBigFrame"]];
    
    
    [self addSubview:bg];
    
    // Name label
    CGRect nameFrame =  CGRectMake(10, self.frame.size.height-30, self.frame.size.width, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12.f : 10.f;
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.data objectForKey:@"Name"];
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    [nameLabel sizeToFit];
    [self addSubview:nameLabel];
    
    int hours, minutes, seconds;
    seconds =[[self.data objectForKey:@"Length"] intValue];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
    
    CGRect timeFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(self.frame.size.width-40, self.frame.size.height-30, 50, 20) :
    CGRectMake(self.frame.size.width-33, self.frame.size.height-28, 50, 20);
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    timeLabel.backgroundColor=  nameLabel.backgroundColor;
    timeLabel.font = nameLabel.font;
    timeLabel.textColor = [UIColor colorWithRed:98/255.f
                                          green:94/255.f
                                           blue:91/255.f alpha:1];
    [self addSubview:timeLabel];
    
    // Setup image view
    CGRect frame;
    
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPhoneInAppPictureFrame) : (frame = iPhoneInAppPictureFrame);
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:[UIImage imageNamed:[self.data objectForKey:@"Image"]]];
    [self addSubview:centerView];

}
- (void)setupCanvasFrame
{
    if (self.itemType == kPoseFrame)
    {
        [self setupCanvasPoseFrame];
    }
    else
    {
        [self setupCanvasSequenceFrame];
    }
}
- (void)setupCanvasPoseFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    // Get the cooling color
    if ([[self.data objectForKey:@"Effect"] isEqualToString:@"E"])
        [bg setImage:[UIImage imageNamed:@"redSmallFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"C"])
        [bg setImage:[UIImage imageNamed:@"blueSmallFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"N"])
        [bg setImage:[UIImage imageNamed:@"yellowSmallFrame"]];
    
    [self addSubview:bg];
    
    // Name label
    CGRect nameFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(11,self.frame.size.height-30, 100, 20) :
    CGRectMake(8, self.frame.size.height-25, 100, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12.f : 8.f;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.data objectForKey:@"Name"];
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    [self addSubview:nameLabel];
    
    int hours, minutes, seconds;
    seconds =[[self.data objectForKey:@"Length"] intValue];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
    
    CGRect timeFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(self.frame.size.width-35, self.frame.size.height-30,50, 20) :
    CGRectMake(self.frame.size.width-25, self.frame.size.height-25, 50, 20);
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    timeLabel.backgroundColor=  nameLabel.backgroundColor;
    timeLabel.font = nameLabel.font;
    timeLabel.textColor = [UIColor colorWithRed:98/255.f
                                          green:94/255.f
                                           blue:91/255.f alpha:1];
    [self addSubview:timeLabel];
    
    
    // Setup image view
    CGRect frame;
    
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPadCanvasPictureFrame) : (frame = iPhoneCanvasPictureFrame);
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:[UIImage imageNamed:[self.data objectForKey:@"Image"]]];
    [self addSubview:centerView];
    
    
    
    if ([[self.data objectForKey:@"Unlocked"] boolValue] == NO)
    {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tap];
        
        UIImageView *lockedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedFrame"]];
        lockedImg.contentMode = UIViewContentModeScaleAspectFill;
        
        CGRect lockedFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
        CGRectMake(5,8,179, 99) :
        CGRectMake(5, 4, 105, 61);
        lockedImg.alpha = 0.5;
        lockedImg.frame = lockedFrame;
        [self addSubview:lockedImg];
    }


}
- (void)setupCanvasSequenceFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"graySmallFrame"]];
    [self addSubview:bg];
    
    
    CGRect nameFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(11,self.frame.size.height-30, 100, 20) :
    CGRectMake(8, self.frame.size.height-25, 75, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12.f : 8.f;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.data objectForKey:@"Name"];
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    [nameLabel sizeToFit];
    //[self addSubview:nameLabel];
    
    
    MarqueeLabel *mLabel = [[MarqueeLabel alloc] initWithFrame:nameFrame duration:10 andFadeLength:0.5f];
    mLabel.text = [self.data objectForKey:@"Name"];
    mLabel.font = nameLabel.font;
    mLabel.textColor = nameLabel.textColor;
    mLabel.textAlignment = NSTextAlignmentLeft;
    //mLabel.marqueeType = MLContinuous;
    [self addSubview:mLabel];
    
    int hours, minutes, seconds;
    seconds =[SSY getTotalLengthOfPoses:[self.data objectForKey:@"Poses"]];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
    
    CGRect timeFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(self.frame.size.width-35, self.frame.size.height-30,50, 20) :
    CGRectMake(self.frame.size.width-25, self.frame.size.height-25, 50, 20);

    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    timeLabel.backgroundColor=  nameLabel.backgroundColor;
    timeLabel.font = nameLabel.font;
    timeLabel.textColor = [UIColor colorWithRed:98/255.f
                                          green:94/255.f
                                           blue:91/255.f alpha:1];
    [self addSubview:timeLabel];
    
    // Setup image view
    CGRect frame;
    NSArray *poses = [self.data objectForKey:@"Poses"];
    UIImage *image = [SSY getImageForPose:[poses objectAtIndex:0]];
    
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPadCanvasPictureFrame) : (frame = iPhoneCanvasPictureFrame);
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:image];
    [self addSubview:centerView];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self addGestureRecognizer:tap];

    
    
    if ([[self.data objectForKey:@"Unlocked"] boolValue] == NO)
    {
        UIImageView *lockedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedFrame"]];
        lockedImg.contentMode = UIViewContentModeScaleAspectFill;
        
        CGRect lockedFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
        CGRectMake(5,8,179, 99) :
        CGRectMake(5, 4, 105, 61);
        lockedImg.alpha = 0.5;
        lockedImg.frame = lockedFrame;
        [self addSubview:lockedImg];
    }


}
- (void)setupTimelineFrame
{
    if (self.itemType == kPoseFrame)
    {
        [self setupTimelinePoseFrame];
    }
    else
        [self setupTimelineSequenceFrame];
}
- (void)setupTimelineSequenceFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"greyBigFrame"]];
    
    [self addSubview:bg];

    
    // Name label
    
    CGRect nameFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(11,self.frame.size.height-30, 100, 20) :
    CGRectMake(8, self.frame.size.height-23, 75, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12.f : 10.f;

    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.data objectForKey:@"Name"];
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    [self addSubview:nameLabel];
    
    int hours, minutes, seconds;
    seconds =[SSY getTotalLengthOfPoses:[self.data objectForKey:@"Poses"]];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
    
    
    CGRect timeFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(self.frame.size.width-40, self.frame.size.height-30, 50, 20) :
    CGRectMake(self.frame.size.width-30, self.frame.size.height-25, 50, 20);
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    timeLabel.backgroundColor=  nameLabel.backgroundColor;
    timeLabel.font = nameLabel.font;
    timeLabel.textColor = [UIColor colorWithRed:98/255.f
                                          green:94/255.f
                                           blue:91/255.f alpha:1];
    [self addSubview:timeLabel];
    
    // Setup image view
    CGRect frame;
    NSArray *poses = [self.data objectForKey:@"Poses"];
    UIImage *image = [SSY getImageForPose:[poses objectAtIndex:0]];
    
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPadTimelinePictureFrame) : (frame = iPhoneTimelinePictureFrame);
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:image];
    [self addSubview:centerView];

    
    

}
- (void)setupTimelinePoseFrame
{
    // Setup background
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                                                    self.frame.size.height)];
    // Get the cooling color
    if ([[self.data objectForKey:@"Effect"] isEqualToString:@"E"])
        [bg setImage:[UIImage imageNamed:@"redBigFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"C"])
        [bg setImage:[UIImage imageNamed:@"blueBigFrame"]];
    else if ([[self.data objectForKey:@"Effect"] isEqualToString:@"N"])
        [bg setImage:[UIImage imageNamed:@"yellowBigFrame"]];
    
    
    [self addSubview:bg];
    
    // Name label
    CGRect nameFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(11,self.frame.size.height-30, 100, 20) :
    CGRectMake(8, self.frame.size.height-23, 75, 20);
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 14.f : 10.f;

    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [self.data objectForKey:@"Name"];
    nameLabel.font = [UIFont fontWithName:@"Bebas" size:fontSize];
    nameLabel.textColor = [UIColor colorWithRed:143/255.f
                                          green:143/255.f
                                           blue:143/255.f alpha:1];
    [nameLabel sizeToFit];
    [self addSubview:nameLabel];
    
    int hours, minutes, seconds;
    seconds =[[self.data objectForKey:@"Length"] intValue];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
    
    CGRect timeFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(self.frame.size.width-40, self.frame.size.height-30, 50, 20) :
    CGRectMake(self.frame.size.width-30, self.frame.size.height-25, 50, 20);

    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    timeLabel.backgroundColor=  nameLabel.backgroundColor;
    timeLabel.font = nameLabel.font;
    timeLabel.textColor = [UIColor colorWithRed:98/255.f
                                          green:94/255.f
                                           blue:91/255.f alpha:1];
    [self addSubview:timeLabel];
    
    // Setup image view
    CGRect frame;
    
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (frame = iPadTimelinePictureFrame) : (frame = iPhoneTimelinePictureFrame);
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:frame];
    [centerView setImage:[UIImage imageNamed:[self.data objectForKey:@"Image"]]];
    [self addSubview:centerView];


}

- (void)viewTapped
{
    
    if ([[self.data objectForKey:@"Unlocked"] boolValue] == NO &&
        (self.frameType != kInAppSequenceFrame && self.frameType != kInAppPoseFrame && self.frameType != kInAppPackageFrame))
    {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showInAppPurchaseForItem:)])
            {
                [self.delegate showInAppPurchaseForItem:self];
                
            }
                
        return;
    }

    
    if ([[self.data objectForKey:@"Everything"] boolValue] == YES)
        return;
    
    if (self.frameType == kiPhoneCanvasFrame && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showPoses:)])
        {
            [self.delegate showPoses:[self.data objectForKey:@"Poses"]];
        }
        return;
    }

    
    if (isFlipping) return;
    
    isFlipping = !isFlipping;
    
   [UIView transitionWithView:self duration:0.5f
                      options:UIViewAnimationOptionTransitionFlipFromRight
                   animations:^{
                       if (!isFlipped)
                       {
                           [self showSequenceTable];
                       }
                       else
                       {
                           [self removeSequenceTable];
                       }
                       
                   } completion:^(BOOL finished) {
                       
                       isFlipped = !isFlipped;
                       isFlipping = !isFlipping;
                       
                   }];
}
- (void)removeSequenceTable
{
    [tableFrameBG removeFromSuperview];
    [m_tableView removeFromSuperview];
    m_tableView.delegate = nil;
    m_tableView.dataSource = nil;
    m_tableView = nil;
    tableFrameBG = nil;
}
- (void)showSequenceTable
{
    
    tableFrameBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [tableFrameBG setImage:[UIImage imageNamed:@"tableFrameBG"]];
    [self addSubview:tableFrameBG];
    if (m_tableView == nil)
    {
        CGRect tableFrame = CGRectMake(5, 4, tableFrameBG.frame.size.width-9, tableFrameBG.frame.size.height-12);
        m_tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        m_tableView.backgroundColor = [UIColor clearColor];
        [m_tableView setAllowsSelection:NO];
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        [self addSubview:m_tableView];
    }
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.frameType == kInAppPackageFrame)
    {
        NSArray *sequences = [self.data objectForKey:@"Sequences"];
        cell.textLabel.text = [sequences objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Bebas" size:10.f];
        [cell.textLabel sizeToFit];
        return cell;
    }
    // Configure the cell...
    NSArray *poses = [self.data objectForKey:@"Poses"];
    cell.imageView.image = [SSY getImageForPose:[poses objectAtIndex:indexPath.row]];
    cell.textLabel.text = [poses objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Bebas" size:10.f];
    [cell.textLabel sizeToFit];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.frameType == kInAppPackageFrame)
    {

        return [[self.data objectForKey:@"Sequences"] count];
    }
    else
    return [[self.data objectForKey:@"Poses"] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
@end
