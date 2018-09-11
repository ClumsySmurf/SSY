//
//  PurchaseViewController.h
//  SSY
//
//  Created by John Hamilton on 2/9/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"
//#import "MKStoreManager.h"
#import <StoreKit/StoreKit.h>
#import "DEStoreKitManager.h"

@protocol PurchaseViewControllerDelegate <NSObject>

@optional
-(void)didMakePurchase;
-(void)purchaseViewClosed;

@end
@interface PurchaseViewController : GAITrackedViewController <UIScrollViewDelegate>
{
    ItemType itemType;
    NSArray *packages;
    NSDictionary *data;
    int currentPage;
    NSTimer *timeout;
    NSString *descTitle;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, assign) id <PurchaseViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *purchaseName;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UILabel *m_descLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_purchaseBttn;
@property (weak, nonatomic) IBOutlet UIView *m_bgView;
@property (weak, nonatomic) IBOutlet UIPageControl *m_pageControl;
@property (nonatomic) BOOL isShowing;

- (void)showPackages;
- (void)showSequence:(NSDictionary *)sequence;
- (void)showPose:(NSDictionary *)pose;
- (IBAction)PurchaseAction:(id)sender;
- (void)scrollToItem:(NSUInteger)item;

@end
