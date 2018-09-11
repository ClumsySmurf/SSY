//
//  InfoViewController.h
//  SSY
//
//  Created by John Hamilton on 1/24/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import <Social/Social.h>
#import "GuidelineViewController.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@protocol InfoViewControllerDelegate <NSObject>
@optional
- (void)showAppPackages;
- (void)showTutorial;
- (void)restoredPurchases;
- (void)showInAppPurchaseForItem:(id)frame;
@end

@interface InfoViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *options;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (nonatomic, assign) id <InfoViewControllerDelegate> delegate;
@property (strong, nonatomic)  WebViewController *webView;
- (void)closeAction;
@end
