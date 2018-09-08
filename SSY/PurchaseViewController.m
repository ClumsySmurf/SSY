//
//  PurchaseViewController.m
//  SSY
//
//  Created by John Hamilton on 2/9/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "PurchaseViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

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
    
    
  //  UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    //[self.navBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    UIButton *closeBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBttn.frame= CGRectMake(0, 0, 49, 25);
    [closeBttn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBttn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *savedItem = [[UIBarButtonItem alloc] initWithCustomView:closeBttn];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIColor *defColor = [UIColor colorWithRed:86/255.f green:77/255.f
                                         blue:67/255.f alpha:1];

    UIFont *font = [UIFont fontWithName:@"Bebas" size:12.f];
    closeBttn.titleLabel.font = font;
    closeBttn.titleLabel.textColor = defColor;
    closeBttn.tintColor = closeBttn.titleLabel.textColor;
    
    [closeBttn setTitleColor:defColor forState:UIControlStateNormal];
    [closeBttn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    item.leftBarButtonItem = savedItem;

    
    [self.navBar pushNavigationItem:item animated:NO];
    
    
    self.purchaseName.font = [UIFont fontWithName:@"AvenirNext-Bold" size:14.f];
    self.purchaseName.textColor = [UIColor colorWithRed:37/255.f
                                                  green:34/255.f
                                                   blue:31/255.f alpha:1];
    
    for(NSString* family in [UIFont fontNamesForFamilyName:@"Avenir Next"]) {
        NSLog(@"%@", family);
        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"font:  %@", name);
        }
    }
    
    self.m_descLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:16.f];
    
    
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Purchase Screen";
    
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
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(purchaseViewClosed)])
                                    {
                                        [self.delegate purchaseViewClosed];
                                    }
                                     
                                 }
                             }];
        }
    }];
}

- (void)showPose:(NSDictionary *)pose
{
    

    FrameType fType = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kInAppPoseFrame : kInAppPoseFrame;
    
    CGSize frameSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(220, 143) : CGSizeMake(220, 143);
    FrameView *frame = [[FrameView alloc] initWithFrameType:fType
                                                   itemType:kPoseFrame andObject:pose andFrame:CGRectMake( (self.m_scrollView.frame.size.width/2) - (frameSize.width/2), 0, frameSize.width,
                                                                                                          frameSize.height)];
    
    [self.m_purchaseBttn setTitle:[NSString stringWithFormat:@"Buy for %@",[pose objectForKey:@"Price"]] forState:UIControlStateNormal];
    [self.m_purchaseBttn.titleLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Bold" size:18.f]];
    self.purchaseName.text = [pose objectForKey:@"Name"];
    [self.m_scrollView addSubview:frame];
    
    self.m_descLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.f];
    self.m_descLabel.text = @"Unlocks this pose!";
    descTitle = self.m_descLabel.text;
    itemType = kPoseFrame;
    data = pose;
    
    
    packages = [SSY getPackages];
    self.m_pageControl.hidden = NO;
    float offset = (self.m_scrollView.frame.size.width/2) - (frameSize.width/2);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_pageControl.numberOfPages = [packages count];
    
    for (int i = 0; i<[packages count]; i++)
    {
        NSDictionary *pkg = [packages objectAtIndex:i];
        
        FrameView *frame = [[FrameView alloc] initWithFrameType:kInAppPackageFrame
                                                       itemType:kSequenceFrame andObject:pkg
                                                       andFrame:CGRectMake( ((i+1)*self.m_scrollView.frame.size.width) + offset, 0, frameSize.width,
                                                                           frameSize.height)];
        [self.m_scrollView addSubview:frame];
        
    }
    
    
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * ([packages count] +1 ), self.m_scrollView.contentSize.height);
    self.m_scrollView.pagingEnabled = YES;
    [self scrollViewDidScroll:self.m_scrollView];
    
    self.m_pageControl.numberOfPages = [packages count] + 1;
    
    

}

- (void)timeout
{
    [timeout invalidate];
    [self showAlertWithTitle:@"Error" andMsg:@"Failed to connect to the App Store, please try agian later"];
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (IBAction)PurchaseAction:(UIButton *)sender {
    


    if (itemType == kPackageFrame)
    {
        NSDictionary *package = [packages objectAtIndex:currentPage];
        
        NSLog(@"Trying to purchase package; %@", package.debugDescription);
    
        [[MKStoreManager sharedManager] buyFeature:[package objectForKey:@"App"]
                                    onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                        [SSY unlockPackage:[packages objectAtIndex:currentPage]];
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        [self trackPurchasedPackage:package receipt:purchasedReceipt];
                                      
                                        [self closeAction];
                                    } onCancelled:^{
                                        NSLog(@"Cancelled");
                                      //  [timeout invalidate];
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    }];
    }
    else
    {
        if (currentPage == 0)
        {
            [[MKStoreManager sharedManager] buyFeature:[data objectForKey:@"App"]
                                        onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                        
                                            if (itemType == kPoseFrame)
                                                [SSY unlockPose:[data objectForKey:@"Name"]];
                                            else
                                                [SSY unlockSequenceWithIdentifier:data[@"App"]];
                                            
                                            [self trackPurchasedPackage:data receipt:purchasedReceipt];
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            [self closeAction];
                                        } onCancelled:^{
                                            NSLog(@"Cancelled");
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        }];
        }
        else
        {
            NSDictionary *package = [packages objectAtIndex:currentPage-1];
            
            NSLog(@"Trying to get package: %@", package.debugDescription);
            
            [[MKStoreManager sharedManager] buyFeature:[package objectForKey:@"App"]
                                            onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                                [timeout invalidate];
                                                [self trackPurchasedPackage:package receipt:purchasedReceipt];
                                                [SSY unlockPackage:[packages objectAtIndex:currentPage]];
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                [self closeAction];
                                            } onCancelled:^{
                                                NSLog(@"Cancelled");
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            }];

        }
    }
}
- (void)trackPurchasedPackage:(NSDictionary*)package receipt:(NSData*)receipt {
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *transactionID = [NSString stringWithString:TimeStamp];
    
    NSString *priceString = package[@"Price"];
    float price = [[priceString stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
    
    float revenue =  price * .70f;
    
    
    [tracker send:[[GAIDictionaryBuilder createTransactionWithId:transactionID             // (NSString) Transaction ID
                                                     affiliation:@"In-app Store"         // (NSString) Affiliation
                                                         revenue:[NSNumber numberWithFloat:revenue]                 // (NSNumber) Order revenue (including tax and shipping)
                                                             tax:@0                 // (NSNumber) Tax
                                                        shipping:@0                      // (NSNumber) Shipping
                                                    currencyCode:@"USD"] build]];        // (NSString) Currency code
    
    
    [tracker send:[[GAIDictionaryBuilder createItemWithTransactionId:transactionID         // (NSString) Transaction ID
                                                                name:package[@"Name"]  // (NSString) Product Name
                                                                 sku:package[@"App"]            // (NSString) Product SKU
                                                            category:@"In-App Purchase"  // (NSString) Product category
                                                               price:[NSNumber numberWithFloat:price]               // (NSNumber)  Product price
                                                            quantity:@1                  // (NSInteger)  Product quantity
                                                        currencyCode:@"USD"] build]];    // (NSString) Currency code
    
}

- (void)showAlertWithTitle:(NSString *)title andMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
message:msg delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}
- (void)showSequence:(NSDictionary *)sequence
{
    self.m_pageControl.hidden = YES;
    FrameType fType =  kInAppSequenceFrame;
    
    CGSize frameSize =  CGSizeMake(220, 143);
    FrameView *frame = [[FrameView alloc] initWithFrameType:fType
                                                   itemType:kSequenceFrame andObject:sequence
                                                   andFrame:CGRectMake( (self.m_scrollView.frame.size.width/2) - (frameSize.width/2), 0, frameSize.width,
                                                                                                          frameSize.height)];
    
    [self.m_purchaseBttn setTitle:[NSString stringWithFormat:@"Buy for %@",[sequence objectForKey:@"Price"]] forState:UIControlStateNormal];
    [self.m_purchaseBttn.titleLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Bold" size:18.f]];
    [self.m_scrollView addSubview:frame];
    self.m_descLabel.font = [UIFont fontWithName:@"Avenir Next" size:14.f];
    self.m_descLabel.text = @"Unlocks this sequence and all poses within it";
    descTitle = self.m_descLabel.text;
    itemType = kSequenceFrame;
    
    self.purchaseName.text = [sequence objectForKey:@"Name"];
    data = sequence;
    
    packages = [SSY getPackages];
    self.m_pageControl.hidden = NO;
    float offset = (self.m_scrollView.frame.size.width/2) - (frameSize.width/2);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_pageControl.numberOfPages = [packages count];
    
    for (int i = 0; i<[packages count]; i++)
    {
        NSDictionary *pkg = [packages objectAtIndex:i];
        
        FrameView *frame = [[FrameView alloc] initWithFrameType:kInAppPackageFrame
                                                       itemType:kSequenceFrame andObject:pkg
                                                       andFrame:CGRectMake( ((i+1)*self.m_scrollView.frame.size.width) + offset, 0, frameSize.width,
                                                                           frameSize.height)];
        [self.m_scrollView addSubview:frame];
        
    }
    
    
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * ([packages count] +1 ), self.m_scrollView.contentSize.height);
    self.m_scrollView.pagingEnabled = YES;
    [self scrollViewDidScroll:self.m_scrollView];
    
    self.m_pageControl.numberOfPages = [packages count] + 1;

}

- (void)showPackages
{
    packages = [self arrayByRemovingFreeItems:[SSY getPackages]];
    self.m_pageControl.hidden = NO;
    CGSize frameSize = CGSizeMake(220, 143);
    float offset = (self.m_scrollView.frame.size.width/2) - (frameSize.width/2);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_pageControl.numberOfPages = [packages count];
    
    for (int i = 0; i<[packages count]; i++)
    {
        NSDictionary *pkg = [packages objectAtIndex:i];
        
              FrameView *frame = [[FrameView alloc] initWithFrameType:kInAppPackageFrame
                                                       itemType:kSequenceFrame andObject:pkg
                                                       andFrame:CGRectMake( (i*self.m_scrollView.frame.size.width) + offset, 0, frameSize.width,
                                                                           frameSize.height)];
       
        [self.m_scrollView addSubview:frame];
        itemType = kPackageFrame;
        
    }

    
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * [packages count], self.m_scrollView.contentSize.height);
    self.m_scrollView.pagingEnabled = YES;
    [self scrollViewDidScroll:self.m_scrollView];
}

- (NSArray*)arrayByRemovingFreeItems:(NSArray*)input {
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSDictionary* item in input) {
        if (item[@"Price"] && [item[@"Unlocked"] boolValue] != YES) {
            [result addObject:item];
            //NSLog(@"adding %@ with price: %@",pose[@"Name"], pose[@"Price"]);
        } else {
            NSLog(@"Removing item: %@", item[@"Name"]);
        }
    }
    
    return result;
}

- (void)scrollToItem:(NSUInteger)item {
    CGFloat pageWidth = self.m_scrollView.frame.size.width;
    [self.m_scrollView setContentOffset:CGPointMake(item*pageWidth, 0) animated:YES];

}

#pragma mark - SCROLLVIEW DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.m_pageControl.currentPage = currentPage;
    [self updateDisplay];
}
- (void)updateDisplay
{
    
    if (itemType == kPoseFrame || itemType == kSequenceFrame )
    {
        if (currentPage > 0 && currentPage-1 < [packages count])
        {
            NSDictionary *package = [packages objectAtIndex:currentPage-1];
            [self.m_purchaseBttn setTitle:[NSString stringWithFormat:@"Buy for %@",[package objectForKey:@"Price"]] forState:UIControlStateNormal];
            [self.m_purchaseBttn.titleLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Bold" size:18.f]];
    
            self.m_descLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.f];
            self.m_descLabel.text = [package objectForKey:@"Desc"];
            self.purchaseName.text = [package objectForKey:@"Name"];
        }
        else if (currentPage == 0)
        {
            [self.m_purchaseBttn setTitle:[NSString stringWithFormat:@"Buy for %@",[data objectForKey:@"Price"]] forState:UIControlStateNormal];
            [self.m_purchaseBttn.titleLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Bold" size:18.f]];
            self.purchaseName.text = [data objectForKey:@"Name"];
            self.m_descLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.f];
            self.m_descLabel.text = descTitle;

        }
    }
    else
    {
        if (currentPage < [packages count])
        {
        
            NSDictionary *package = [packages objectAtIndex:currentPage];
            [self.m_purchaseBttn setTitle:[NSString stringWithFormat:@"Buy for %@",
                                           [package objectForKey:@"Price"]] forState:UIControlStateNormal];
            [self.m_purchaseBttn.titleLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Bold" size:18.f]];
        
            self.m_descLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.f];
            self.m_descLabel.text = [package objectForKey:@"Desc"];
            self.purchaseName.text = [package objectForKey:@"Name"];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
