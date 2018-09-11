//
//  ViewController.m
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "ViewController.h"
#import "Apptentive.h"
//#import "ATConnect_Debugging.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	
    
    //[[Apptentive sharedConnection] setDebuggingOptions:ATConnectDebuggingOptionsShowDebugPanel];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SSY checkSSYData];
        [MKStoreManager sharedManager];
        [[Apptentive sharedConnection] setAppID:@"599114266"];
        //[[Apptentive sharedConnection] setShowTagline:NO];
        [[Apptentive sharedConnection] engage:@"init" fromViewController:self];
        
    });

    

    
    self.m_canvasViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasView"];
    self.m_savedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedView"];
    self.m_savedViewController.delegate = self;
    
   
    
    //ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    
    self.topViewController = self.m_canvasViewController;
    
    [[Apptentive sharedConnection] engage:@"did_finish_launching" fromViewController:self];

}

- (void)savedSequenceTouched:(NSDictionary *)sequence
{
    NSLog(@"saved sequence touched");
    [self.m_canvasViewController addSequence:sequence];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
