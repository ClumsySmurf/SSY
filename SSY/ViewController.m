//
//  ViewController.m
//  SSY
//
//  Created by John Hamilton on 1/16/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "ViewController.h"
#import "ATConnect.h"
#import "ATConnect_Debugging.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	
    
    //[[ATConnect sharedConnection] setDebuggingOptions:ATConnectDebuggingOptionsShowDebugPanel];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SSY checkSSYData];
        [MKStoreManager sharedManager];
        [[ATConnect sharedConnection] setApiKey:@"0cee6b30437f17c3cb20c570b896efe5855bf03b10239a3477cf6d0cc174d0d9"];
        
        [[ATConnect sharedConnection] setShowTagline:NO];
        [[ATConnect sharedConnection] setAppID:@"599114266"];
        [[ATConnect sharedConnection] engage:@"init" fromViewController:self];
        
    });

    

    
    self.m_canvasViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasView"];
    self.m_savedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedView"];
    self.m_savedViewController.delegate = self;
    
   
    
    //ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    
    self.topViewController = self.m_canvasViewController;
    
    [[ATConnect sharedConnection] engage:@"did_finish_launching" fromViewController:self];

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
