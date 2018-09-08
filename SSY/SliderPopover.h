//
//  SliderPopover.h
//  SSY
//
//  Created by John Hamilton on 2/1/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderPopoverDelegate <NSObject>

@optional
- (void)sliderValueChanged:(float)value;

@end

@interface SliderPopover : UIView

@property (nonatomic, strong) UISlider *m_slider;
@property (nonatomic, assign) id <SliderPopoverDelegate> delegate;
@property BOOL isShown;

- (id)initFromPoint:(CGPoint)point;


@end
