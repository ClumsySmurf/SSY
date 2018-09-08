//
//  SharePopover.h
//  SSY
//
//  Created by John Hamilton on 1/22/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol SharePopoverDelegate <NSObject>

@optional
-(void)facebookShareAction;
-(void)twitterShareAction;
-(void)popoverCancelled;

@end
@interface SharePopover : UIView


@property(nonatomic, assign) id <SharePopoverDelegate> delegate;
@property (nonatomic) BOOL isShown;


- (id)initFromPoint:(CGPoint)point;
- (void)hidePopover;
@end
