//
//  FrameView.h
//  SSY
//
//  Created by John Hamilton on 1/18/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
@protocol FrameViewDelegate <NSObject>

@optional
- (void)frameWasTouched:(id)frame;
- (void)showInAppPurchaseForItem:(id)frame;
- (void)showPoses:(NSArray *)poses;
@end


typedef enum FrameType
{
    kiPadTimelineFrame,
    kiPadCanvasFrame,
    kiPhoneTimelineFrame,
    kiPhoneCanvasFrame,
    kInAppPoseFrame,
    kInAppSequenceFrame,
    kInAppPackageFrame
} FrameType;

typedef enum ItemType
{
    kSequenceFrame,
    kPoseFrame,
    kPackageFrame
} ItemType;

@interface FrameView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *m_tableView;
    BOOL isFlipped;
    NSMutableArray *packages;
    int currentIndex;
    UIImageView *tableFrameBG;
}

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic) FrameType frameType;
@property (nonatomic) ItemType itemType;
@property (nonatomic,assign) id <FrameViewDelegate> delegate;

- (id)initWithFrameType:(FrameType)frameType itemType:(ItemType)type
andObject:(NSDictionary *)object andLocation:(CGPoint)location;
- (id)initWithFrameType:(FrameType)frameType
               itemType:(ItemType)type andObject:(NSDictionary *)object andFrame:(CGRect)frame;

- (void)setupCanvasFrame;
- (void)setupTimelineFrame;

@end
