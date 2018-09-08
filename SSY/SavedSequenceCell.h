//
//  SavedSequenceCell.h
//  SSY
//
//  Created by John Hamilton on 1/25/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedSequenceCell : UITableViewCell


@property (nonatomic, assign) IBOutlet UIImageView *seqImg;
@property (nonatomic, assign) IBOutlet UILabel *nameLabel, *timeLabel;
@property (nonatomic, assign) IBOutlet UIImageView *poseImageView;

@end
