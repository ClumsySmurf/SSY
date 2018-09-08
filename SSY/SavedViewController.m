//
//  SavedViewController.m
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "SavedViewController.h"

@interface SavedViewController ()

@end

@implementation SavedViewController

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
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    
    UIImage *header = [UIImage imageNamed:@"sequenceImage"];
    UIImageView *headerView = [[UIImageView alloc] initWithImage:header];
    
    [self.m_navBar setBackgroundImage:[UIImage imageNamed:@"savedNavBar"] forBarMetrics:UIBarMetricsDefault];
    item.titleView = nil;
    
    float offset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 110.f : 40.f;
    float yOffset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20.f  : 10.f;
     headerView.frame = CGRectMake(offset, yOffset, header.size.width, header.size.height);
    item.titleView.transform = CGAffineTransformMakeTranslation(offset, 0);
    [self.m_navBar addSubview:headerView];
    //[self.m_navBar pushNavigationItem:item animated:NO];
    
    
    sequences = [NSMutableArray arrayWithArray:[SSY getSavedSequences]];
    
    [self.m_tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (IBAction)closeAction:(id)sender {
     [self.slidingViewController resetTopView];
}
- (void)viewDidLoad {
    
    // Set our class
    //[self.m_tableView registerClass:[SavedSequenceCell class] forCellReuseIdentifier:@"Cell"];

    
    [super viewDidLoad];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    SavedSequenceCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[SavedSequenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *seq = [sequences objectAtIndex:indexPath.row];
    
    // Name label
    cell.nameLabel.text = [seq objectForKey:@"Name"];
    cell.nameLabel.font = [UIFont fontWithName:@"Bebas" size:12.f];
    cell.nameLabel.textColor = [UIColor whiteColor];
    int hours, minutes, seconds;
    seconds =[SSY getTotalLengthOfPoses:[seq objectForKey:@"Poses"]];
    hours = seconds / 3600;
    minutes = (seconds - (hours*3600)) / 60;
    seconds = seconds % 60;
       
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    cell.timeLabel.backgroundColor=  cell.nameLabel.backgroundColor;
    cell.timeLabel.font = cell.nameLabel.font;
    cell.timeLabel.textColor = [UIColor whiteColor];
    
    // Setup image view
    NSArray *poses = [seq objectForKey:@"Poses"];
    UIImage *image = [SSY getImageForPose:[poses objectAtIndex:0]];
    cell.seqImg.image = image;

    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(savedSequenceTouched:)])
    {
        NSLog(@"Trigger sequence delegate");
        NSDictionary *seq = [sequences objectAtIndex:indexPath.row];
        [self.delegate savedSequenceTouched:seq];
        [self.slidingViewController resetTopView];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [sequences count];
}
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
       [sequences removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
     [SSY updateSavedSequences:[NSArray arrayWithArray:sequences]];
   
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
@end
