//
//  SavedViewController.h
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedSequenceCell.h"
#import "ECSlidingViewController.h"

@protocol SavedViewControllerDelegate <NSObject>

@optional
-(void)savedSequenceTouched:(NSDictionary *)sequence;

@end
@interface SavedViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *sequences;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *m_navBar;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (nonatomic, assign) id <SavedViewControllerDelegate> delegate;

@end
