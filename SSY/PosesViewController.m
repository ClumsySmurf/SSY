//
//  PosesViewController.m
//  SSY
//
//  Created by John Hamilton on 2/10/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "PosesViewController.h"

@interface PosesViewController ()

@end

@implementation PosesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.navBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    UIButton *closeBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBttn.frame= CGRectMake(0, 0, 49, 25);
    [closeBttn setBackgroundImage:[UIImage imageNamed:@"navEditBttn"] forState:UIControlStateNormal];
    [closeBttn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBttn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *savedItem = [[UIBarButtonItem alloc] initWithCustomView:closeBttn];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Information"];
    
    UIFont *font = [UIFont fontWithName:@"Bebas" size:12.f];
    closeBttn.titleLabel.font = font;
    closeBttn.titleLabel.textColor = [UIColor colorWithRed:86/255.f green:77/255.f
                                                      blue:67/255.f alpha:1];
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    float navSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.f : 14.f;
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:navSize];
    navLabel.text=@"Poses";
    navLabel.textAlignment = NSTextAlignmentCenter;
    item.titleView = navLabel;
    
    item.leftBarButtonItem = savedItem;
    
    
    [self.navBar pushNavigationItem:item animated:NO];
    
    
    
    
    [super viewWillAppear:animated];
    
      self.screenName = @"Poses Screen";
    
}

- (void)closeAction
{
    [UIView animateWithDuration:0.2f animations:^{
        self.m_bgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
                             } completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     if (self.delegate && [self.delegate respondsToSelector:@selector(poseViewDidClose)])
                                     {
                                         [self.delegate poseViewDidClose];
                                     }
                                     
                                 }
                             }];
        }
    }];
}

- (void)viewDidLoad
{
    self.poses = [NSArray array];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadPoses:(NSArray *)poses
{
    self.poses = poses;
    [self.m_tableView reloadData];
    
}

#pragma mark - Tableview Delegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [SSY getImageForPose:[self.poses objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.poses objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Bebas" size:10.f];


    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.poses count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
@end
