//
//  PurchaseTableViewCell.h
//  SSY
//
//  Created by John Hamilton on 6/29/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PurchaseTableViewCellDelegate <NSObject>

@optional
- (void)purchaseTappedForItem:(id)item withTag:(NSUInteger)tag;
@end
@interface PurchaseTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL shouldRoundItems;
@property (nonatomic, assign) id<PurchaseTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isFeaturedCell;
- (void)loadData:(NSArray*)data withName:(NSString*)name;

@end
