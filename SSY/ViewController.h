//
//  ViewController.h
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasViewController.h"
#import "SavedViewController.h"
#import "ECSlidingViewController.h"

@interface ViewController : ECSlidingViewController <SavedViewControllerDelegate>



@property (nonatomic, strong) CanvasViewController *m_canvasViewController;
@property (nonatomic, strong) SavedViewController *m_savedViewController;
@property (nonatomic, strong) UINavigationController *m_canvasNavigationController;

@end
