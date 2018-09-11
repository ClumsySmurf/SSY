//
//  InfoViewController.m
//  SSY
//
//  Created by John Hamilton on 1/24/13.
//  Copyright (c) 2013 SnapApps LLC. All rights reserved.
//

#import "InfoViewController.h"
//#import "MKStoreManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBttn;

@end

@implementation InfoViewController

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
    [super viewWillAppear:animated];
      self.screenName = @"Info Screen";
    //[self.navigationController.navigationBar setItems:@[[self navigationItem]] animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (IBAction)closeInfoView:(id)sender {
    [self closeAction];
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    options = [NSMutableArray array];
    [options addObject:@"IN-APP  PURCHASES"];
    [options addObject:@"ABOUT  US"];
    [options addObject:@"EMAIL  SUPPORT"];
    [options addObject:@"SHARE  TO  FACEBOOK"];
    [options addObject:@"SHARE  TO  TWITTER"];
    [options addObject:@"PURCHASE  DVD"];
    [options addObject:@"GUIDELINES  VIDEO"];
    [options addObject:@"GLOSSARY  AND  NOTES"];
    [options addObject:@"SSY SEQUENCES"];
    [options addObject:@"DISCLAIMER"];
    [options addObject:@"COPYRIGHT"];
    [options addObject:@"TUTORIAL"];
    [options addObject:@"RESTORE  PURCHASES"];
    
    
    UIImage *barBG= [[UIImage imageNamed:@"navBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile];
    [self.navigationController.navigationBar setBackgroundImage:barBG forBarMetrics:UIBarMetricsDefault];
    
    
    
      UIFont *font = [UIFont fontWithName:@"Bebas" size:12.f];
    _closeBttn.titleLabel.font = font;
    _closeBttn.titleLabel.textColor = [UIColor colorWithRed:86/255.f green:77/255.f
                                                       blue:67/255.f alpha:1];
    _closeBttn.frame= CGRectMake(0, 0, 49, 25);
    _closeBttn.titleLabel.font = font;
    _closeBttn.titleLabel.textColor = [UIColor whiteColor];
    _closeBttn.tintColor = [UIColor whiteColor];
    
    [_closeBttn setTitle:@"Close" forState:UIControlStateNormal];

    

    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, 100, 60)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    float navSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.f : 12.f;
    navLabel.font = [UIFont fontWithName:@"Pacifico" size:navSize];
    navLabel.text=@"Sing Song Yoga";
    navLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.navigationItem.titleView = navLabel;
    

    
    _tableView.backgroundColor = [UIColor clearColor];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableviewd delegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Bebas" size:22.f];
    cell.textLabel.shadowOffset = CGSizeMake(1, 0);
    // Configure the cell...
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [options count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self showInAppPurchases];
            [self trackerSendCategory:@"Info Screen" action:@"Showing Purchase View" label:@"Show In App Purchases" andValue:nil];
            break;
        case 1:
            [self showAboutUs];
            [self trackerSendCategory:@"Info Screen" action:@"Show About Us" label:@"Showing About Us" andValue:nil];
            break;
        case 2:
            [self contactDeveloper];
            [self trackerSendCategory:@"Info Screen" action:@"Contact Developer" label:@"Contact Developer" andValue:nil];
            break;
        case 3:
            [self facebookShareAction];
            [self trackerSendCategory:@"Info Screen" action:@"Facebook Share Action" label:@"Showing Facebook Share" andValue:nil];
            break;
        case 4:
            [self twitterShareAction];
            [self trackerSendCategory:@"Info Screen" action:@"Twitter Share Action" label:@"Showing Twitter Share" andValue:nil];
            break;
        case 5:
            [self showDvd];
            [self trackerSendCategory:@"Info Screen" action:@"Show DVD" label:@"Purchase DVD" andValue:nil];
            break;
        case 6:
            [self showGuidelineVideo];
            [self trackerSendCategory:@"Info Screen" action:@"Show Guideline Video" label:@"Guideline Video" andValue:nil];
            break;
        case 7:
            [self showGlossery];
            [self trackerSendCategory:@"Info Screen" action:@"Show Glossery" label:@"Glossery" andValue:nil];
            break;
        case 8:
            [self showSequences];
            [self trackerSendCategory:@"Info Screen" action:@"Show Sequences" label:@"Sequences" andValue:nil];
            break;
        case 9:
            [self showDisclaimer];
            [self trackerSendCategory:@"Info Screen" action:@"Show Disclaimer" label:@"Disclaimer" andValue:nil];
            break;
        case 10:
            [self showCopyright];
            [self trackerSendCategory:@"Info Screen" action:@"Show Copyright" label:@"Copyright" andValue:nil];
            break;
        case 11:
            [self showTutorial];
            [self trackerSendCategory:@"Info Screen" action:@"Show Tutorial" label:@"Tutorial" andValue:nil];
            break;
        case 12:
            [self restorePurchases];
            [self trackerSendCategory:@"Info Screen" action:@"Restore Purchases" label:@"Restore Purchases" andValue:nil];
            break;
        default:
            break;
    }
   
}

#pragma mark - Private

- (void)restorePurchases
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    /*
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{

        NSArray *products  = [[MKStoreManager sharedManager] purchasableObjects];
        
        for (SKProduct *product in products)
        {
            [SSY restorePurchase:product.productIdentifier];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(restoredPurchases)])
        {
            [self.delegate restoredPurchases];
        }
     [self showAlertWithTitle:@"Success" andMsg:@"Your purchases have been restored."];
    } onError:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWithTitle:@"Error" andMsg:@"Something went wrong restoring your purchaes, please try again"];
    }];
    */
       
}
- (void)showTutorial
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(showTutorial)])
        {
            [self.delegate showTutorial];
        }
    }];
  
}
- (void)showSequences
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showSequences];
}
- (void)showCopyright
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showCopyright];
}
- (void)showInAppPurchases
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showInAppPurchaseForItem:)])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate showInAppPurchaseForItem:nil];
        }];

    }
}
- (void)showGlossery
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showGlossery];
}
- (void)showDisclaimer
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showDisclaimer];
    

}
- (void)twitterShareAction
{
    
    NSString *phoneShare = @"Doing the #SingSongYoga #kidsyoga #iphone #app with the #kids and loving it!";
    NSString *tabletShare = @"Doing the #SingSongYoga #kidsyoga #ipad #app with the #kids and loving it!";
    
    NSString *msg = [NSString stringWithFormat:@"%@",
                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? tabletShare : phoneShare];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:msg];
        
        [controller addURL:[NSURL URLWithString:@"http://ow.ly/sIwes"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        [self showAlertWithTitle:@"Error" andMsg:@"Please sign into Twitter on your device to allow sharing!"];
        return;
    }

}
- (void)contactDeveloper
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Sing Song Yoga Support"];
        [mail setToRecipients:[NSArray arrayWithObject:@"developer@singsongyoga.com"]];
        [mail setBccRecipients:@[@"ssyappdeveloper@gmail.com"]];
        [self presentViewController:mail animated:YES completion:nil];
        
    }
    else
    {
        [self showAlertWithTitle:@"Error" andMsg:@"Please set up an email account on your device."];
        return;
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)facebookShareAction
{
    
    
    NSString *msg = [NSString stringWithFormat:@"I’ve been using the Sing Song Yoga™ %@ App with the children in my life and we are loving it!  We highly recommend it! Check out the Sample! https://ow.ly/sIwes",
                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone"];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:msg];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:@"http://youtu.be/FqO7v2eUehs"]];
        
        //Adding the Image to the facebook post value from iOS
        
        //[controller addImage:[UIImage imageNamed:@"Mountain"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        [self showAlertWithTitle:@"Error" andMsg:@"Please sign into Facebook on your device to allow sharing!"];
        return;
    }
}
- (void)showAlertWithTitle:(NSString *)title andMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
message:msg delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}
- (void)showGuidelineVideo
{
    GuidelineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"GuidelineView"];
    [self.navigationController pushViewController:view animated:YES];
}
- (void)showAboutUs
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showAboutUs];
}
- (void)showDvd
{
    self.webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    [self.navigationController pushViewController:self.webView animated:YES];
    [self.webView showPurchaseDVD];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (void)trackerSendCategory:(NSString*)cat action:(NSString*)action label:(NSString*)eventLabel andValue:(id)eventValue {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:cat     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:eventLabel         // Event label
                                                           value:eventValue] build]];    // Event value
    
}

@end
