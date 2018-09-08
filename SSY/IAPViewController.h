//
//  IAPViewController.h
//  SSY
//
//  Created by John Hamilton on 6/29/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IAPViewControllerDelegate <NSObject>
@optional
- (void)IAPViewContorllerDidDismiss;
@end
@interface IAPViewController : UIViewController
@property (nonatomic, assign) id <IAPViewControllerDelegate> delegate;
@end
