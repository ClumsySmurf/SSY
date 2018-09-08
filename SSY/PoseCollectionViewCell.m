//
//  PoseCollectionViewCell.m
//  SSY
//
//  Created by John Hamilton on 7/1/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import "PoseCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PoseCollectionViewCell() {
}
@property (nonatomic, assign) IBOutlet UIImageView *poseImageView;
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
@end

@implementation PoseCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupWithItem:(NSDictionary*)item {
    NSLog(@"Loading item: %@", item);
    self.data = item;
    if (self.data[@"Name"] != [NSNull null]) {
        self.titleLabel.text = self.data[@"Name"];
    }
    if (self.data[@"Image"] != [NSNull null] && self.data[@"Image"] != nil) {
        NSString *imageName = [NSString stringWithFormat:@"%@ T", self.data[@"Image"]];
        self.poseImageView.image = [UIImage imageNamed:imageName];
    } else if (self.data[@"Poses"] != [NSNull null]) {
        NSArray *poses = self.data[@"Poses"];
        self.poseImageView.image =[SSY getIAPImageForPose:poses[0]];
        
    }
    if (self.data[@"Price"]) {
        self.titleLabel.text = [self.titleLabel.text stringByAppendingString:[NSString stringWithFormat:@"\n%@", self.data[@"Price"]]];
    }
    
    self.poseImageView.layer.cornerRadius = 0.f;
    self.poseImageView.layer.masksToBounds = NO;
    
    self.poseImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    self.poseImageView.alpha = 0.f;
    
    float random = arc4random() % 1 * .1;
    
    [UIView animateKeyframesWithDuration:0.3f delay:random
                                 options:0 animations:^{
                                     self.poseImageView.alpha = 1.f;
                                     self.poseImageView.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     
                                 }];
    
  
   
}


- (void)roundCorners {
    self.poseImageView.layer.cornerRadius = 8.f;
    self.poseImageView.layer.masksToBounds = YES;
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
