//
//  IAPViewController.m
//  SSY
//
//  Created by John Hamilton on 6/29/14.
//  Copyright (c) 2014 SnapApps LLC. All rights reserved.
//

#import "IAPViewController.h"
#import "PurchaseTableViewCell.h"
#import "PurchaseViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface IAPViewController () <UITableViewDataSource, UITableViewDelegate, PurchaseTableViewCellDelegate, PurchaseViewControllerDelegate> {
    NSDictionary *data;
   
    PurchaseViewController *purchaseView;
}
@property (nonatomic, assign) IBOutlet UITableView *purchaseTableView;
@property (nonatomic, strong)  NSArray *sequences, *standingPoses, *sittingPoses, *floorPoses;
@end

@implementation IAPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

-(void)loadData {
    data = [SSY sequences];
    self.sequences = [self posesByRemovingFreeItems:data[@"Sequences"]];
    
    self.standingPoses = [self posesByRemovingFreeItems:[self loadPosesForCategory:@"Standing"]];
    self.sittingPoses = [self posesByRemovingFreeItems:[self loadPosesForCategory:@"Sitting"]];
    self.floorPoses = [self posesByRemovingFreeItems:[self loadPosesForCategory:@"Floor"]];

}
- (NSArray*)posesByRemovingFreeItems:(NSArray*)poses {
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary* pose in poses) {
        if (pose[@"Price"] && [pose[@"Unlocked"] boolValue] != YES) {
            [result addObject:pose];
            //NSLog(@"adding %@ with price: %@",pose[@"Name"], pose[@"Price"]);
        } else {
            NSLog(@"Removing item: %@", pose[@"Name"]);
        }
    }
    
    return result;
}
-(NSArray*)loadPosesForCategory:(NSString *)category
{
    
    NSArray *selectedPoses = [data objectForKey:@"Poses"];
    
    NSMutableArray *poses = [NSMutableArray array];
    
    for (NSDictionary *pose in selectedPoses)
    {
        if ([[pose objectForKey:@"Category"] isEqualToString:category])
        {
            [poses addObject:pose];
            
        }
    }
    
    return poses;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(IAPViewContorllerDidDismiss)]) {
        [self.delegate IAPViewContorllerDidDismiss];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadNotification" object:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"PurchaseTableViewCell";
    
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    [cell loadData:[self dataSourceForCelltIndexPath:indexPath] withName:[self nameForCellAtIndexPath:indexPath]];
    
    if (indexPath.row == 0 ) {
        cell.isFeaturedCell = YES;
    } else {
        cell.isFeaturedCell = NO;
    }
    
    cell.shouldRoundItems = YES;
    
    cell.delegate = self;
    
    return cell;
}
- (NSArray*)dataSourceForCelltIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [self posesByRemovingFreeItems:[SSY getPackages]];
        case 1:
            return  self.sequences;
        case 2:
            return self.standingPoses;
        case 3:
            return self.sittingPoses;
        case 4:
            return self.floorPoses;
        default:
            return self.sequences;
    }
}
- (NSString*)nameForCellAtIndexPath:(NSIndexPath*)indexPath {
    switch (indexPath.row) {
        case 0:
            return @"Packages";
        case 1:
            return @"Sequences";
        case 2:
            return @"Standing Poses";
        case 3:
            return @"Sitting Poses";
        case 4:
            return @"Floor Poses";
        default:
            return @"";
    }
}


- (void)purchaseTappedForItem:(id)item withTag:(NSUInteger)tag {
    
    
    purchaseView = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseView"];
    purchaseView.delegate = self;
    
    NSDictionary *newItem = (NSDictionary*)item;
    
    [self.view addSubview:purchaseView.view];

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    purchaseView.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    purchaseView.view.center = self.navigationController.view.center;
    } else {
         purchaseView.view.frame = CGRectMake(purchaseView.view.frame.origin.x, purchaseView.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
        purchaseView.view.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
         [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
   purchaseView.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    [UIView animateWithDuration:0.4f
                     animations:^{
                         purchaseView.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [UIView animateWithDuration:0.3f
                                              animations:^{
                                                  purchaseView.m_bgView.alpha = 1;
  
                                                  if (![self isSequence:newItem] && ![self isPose:newItem]) {
                                                      if ([[newItem objectForKey:@"Full"] boolValue] == YES)
                                                      {
                                                          [purchaseView showPackages];
                                                          purchaseView.view.tag = tag;
                                                      } else {
                                                          [purchaseView showPackages];
                                                          [purchaseView scrollToItem:tag];
                                                      }
                                                  }
                                                   else if([self isSequence:newItem])
                                                      {
                                                          [purchaseView showSequence:newItem];
                                                          purchaseView.view.tag = tag;
                                                      } else {
                                                          [purchaseView showPose:newItem];
                                                          purchaseView.view.tag = tag;
                                                      }
                                                  
                                                  
                                                      
                                                  [self trackerSendCategory:@"Canvas Screen" action:@"Showing In-App Purchases"
                                                                      label:[NSString stringWithFormat:@"For Item %@", newItem[@"Name"]] andValue:nil];
                                                  
                                              }];
                         }
                     }];
    

    
}

- (void)trackerSendCategory:(NSString*)cat action:(NSString*)action label:(NSString*)eventLabel andValue:(id)eventValue {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:cat     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:eventLabel         // Event label
                                                           value:eventValue] build]];    // Event value
    
}

- (BOOL)isSequence:(NSDictionary*)item {
    NSArray *poses = item[@"Poses"];
    
    if (poses && poses.count > 0)
        return YES;
    return NO;
}
- (BOOL)isPose:(NSDictionary*)item {
    NSNumber *length = item[@"Length"];
    if (length)
        return YES;
    
    return NO;
}

- (void)purchaseViewClosed {
    purchaseView.delegate = nil;
    purchaseView = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
    [self.purchaseTableView reloadData];
}


@end
