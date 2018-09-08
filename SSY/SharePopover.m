//
//  SharePopover.m
//  SSY
//
//  Created by John Hamilton on 1/22/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "SharePopover.h"

@implementation SharePopover

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
    self = [super initWithFrame:CGRectMake(point.x, point.y, 307, 195)];
    
    if (self)
    {
       // self.layer.anchorPoint = CGPointMake(0.2, 0);
        self.alpha = 0;
        UIImageView *BG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 307, 195)];
        [BG setImage:[UIImage imageNamed:@"popoverBG"]];
        [self addSubview:BG];
        
        self.isShown = YES;
        
        UIButton *twitterBttn = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterBttn setImage:[UIImage imageNamed:@"twitterBttn"] forState:UIControlStateNormal];
        [twitterBttn setFrame:CGRectMake(18, 20, 272, 42)];
        [twitterBttn addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:twitterBttn];
        
        UIButton *fbBttn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fbBttn setImage:[UIImage imageNamed:@"fbButton"] forState:UIControlStateNormal];
        [fbBttn setFrame:CGRectMake(18, 68, 272, 42)];
        [fbBttn addTarget:self action:@selector(facebookAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fbBttn];
        
        UIButton *cancelBttn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBttn setImage:[UIImage imageNamed:@"cancelBttn"] forState:UIControlStateNormal];
        [cancelBttn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [cancelBttn setFrame:CGRectMake(18, 118, 272, 42)];
        [self addSubview:cancelBttn];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
    }
    
    return self;
}

- (void)facebookAction
{
    NSLog(@"facebook action delegate");
  if (self.delegate && [self.delegate respondsToSelector:@selector(facebookShareAction)])
  {
      
      [self.delegate facebookShareAction];
  }
    
    [self hidePopover];
}
- (void)twitterAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(twitterShareAction)])
    {
        [self.delegate twitterShareAction];
    }
    [self hidePopover];

}
- (void)cancelAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverCancelled)])
    {
        [self.delegate popoverCancelled];
    }
    [self hidePopover];
}
- (void)hidePopover
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.isShown = NO;
            [self removeFromSuperview];
        }
    }];
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
