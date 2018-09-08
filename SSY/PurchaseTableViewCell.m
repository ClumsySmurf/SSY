//
//  PurchaseTableViewCell.m
//  SSY
//
//  Created by John Hamilton on 6/29/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import "PurchaseTableViewCell.h"
#import "PoseCollectionViewCell.h"
#import "FeaturedPoseCollectionViewCell.h"

@interface PurchaseTableViewCell() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) IBOutlet UILabel *sectionLabel;
@end


@implementation PurchaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _data = [NSArray new];
    }
    return self;
}
- (void)loadData:(NSArray*)data withName:(NSString*)name {
    _data = data;
    self.sectionLabel.text = name;
    [self.collectionView reloadData];
}



- (void)awakeFromNib
{
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_data.count == 0) ?  1 :_data.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"IAPCollectionCell";
    static NSString *featuredIdentifier = @"FeaturedIAPCollectionCell";
    static NSString *emptyIdentifier = @"EmptyIAPCollectionCell";
    
    id cell = nil;
    
    if (_data.count == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:emptyIdentifier forIndexPath:indexPath];
        return cell;
    }
    if (self.isFeaturedCell) {
        cell = (FeaturedPoseCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:featuredIdentifier forIndexPath:indexPath];


    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    [cell setTag:indexPath.row];
    [cell setupWithItem:_data[indexPath.row]];
    if (self.shouldRoundItems) {
        [cell roundCorners];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFeaturedCell || _data.count == 0) {
        return CGSizeMake(130, 133);
    } else {
        return CGSizeMake(80, 133);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PoseCollectionViewCell *cell = (PoseCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(purchaseTappedForItem:withTag:)]) {
        [self.delegate purchaseTappedForItem:cell.data withTag:cell.tag];
    }

}
@end
