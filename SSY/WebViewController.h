//
//  WebViewController.h
//  SSY
//
//  Created by John Hamilton on 1/24/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : GAITrackedViewController <UIWebViewDelegate>


@property (nonatomic,strong) NSString *link;
@property (strong, nonatomic) IBOutlet UIWebView *m_webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_activityIndicator;

- (void)showAboutUs;
- (void)showPurchaseDVD;
- (void)showDisclaimer;
- (void)showGlossery;
- (void)showCopyright;
- (void)showSequences;
@end
