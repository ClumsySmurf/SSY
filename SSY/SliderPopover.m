//
//  SliderPopover.m
//  SSY
//
//  Created by John Hamilton on 2/1/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "SliderPopover.h"

@implementation SliderPopover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initFromPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 298, 92)];
    
    if (self)
    {
        // self.layer.anchorPoint = CGPointMake(0.2, 0);
        self.alpha = 0;
        UIImageView *BG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 298, 92)];
        [BG setImage:[UIImage imageNamed:@"speedDisplayBG"]];
        [self addSubview:BG];
        
        
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 40, 20)];
        minLabel.backgroundColor = [UIColor clearColor];
        minLabel.text = @"1";
        minLabel.font = [UIFont fontWithName:@"Bebas" size:18.f];
        minLabel.textColor = [UIColor colorWithRed:230/255.f
                                             green:225/255.f
                                              blue:218/255.f alpha:1];
        minLabel.shadowOffset = CGSizeMake(1, 0);
        minLabel.shadowColor = [UIColor blackColor];
        [self addSubview:minLabel];
        
        
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(268, 25, 40, 20)];
        maxLabel.backgroundColor = [UIColor clearColor];
        maxLabel.text = @"30";
        maxLabel.font = minLabel.font;
        maxLabel.textColor = minLabel.textColor;
        maxLabel.shadowOffset = minLabel.shadowOffset;
        maxLabel.shadowColor = minLabel.shadowColor;
        
        [self addSubview:maxLabel];
        
        self.isShown = YES;
        
      
        
        self.m_slider = [[UISlider alloc] initWithFrame:CGRectMake(37, 24.3, 225, 20)];
        self.m_slider.maximumValue = 30;
        self.m_slider.minimumValue = 1;
        [self addSubview:self.m_slider];
        [self.m_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
    }
    
    return self;
}

- (void)sliderChanged
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)])
    {
        [self.delegate sliderValueChanged:self.m_slider.value];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
