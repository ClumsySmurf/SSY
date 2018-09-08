//
//  PoseCollectionViewCell.h
//  SSY
//
//  Created by John Hamilton on 7/1/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoseCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *data;
- (void)setupWithItem:(NSDictionary*)item;
- (void)roundCorners;
@end
