//
//  SavedSequenceCell.m
//  SSY
//
//  Created by John Hamilton on 1/25/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "SavedSequenceCell.h"

@implementation SavedSequenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        
        for (UIView *subview2 in subview.subviews) {
            
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                NSLog(@"found that class yo");
                [subview bringSubviewToFront:subview2];
                
            }
        }
    }
}
@end
