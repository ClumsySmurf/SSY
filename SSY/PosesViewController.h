//
//  PosesViewController.h
//  SSY
//
//  Created by John Hamilton on 2/10/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PoseViewControllerDelegate <NSObject>

@optional
-(void)poseViewDidClose;
@end

@interface PosesViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIView *m_bgView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSArray *poses;
@property (nonatomic, assign) id <PoseViewControllerDelegate> delegate;
- (void)loadPoses:(NSArray*)poses;
@end
