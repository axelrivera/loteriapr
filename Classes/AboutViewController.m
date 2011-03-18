//
//  AboutViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "AboutViewController.h"
#import "InAppPurchaseObserver.h"

@interface AboutViewController (Private)

- (void)productPurchased:(NSNotification *)notification;
- (void)productPurchaseFailed:(NSNotification *)notification;

@end

@implementation AboutViewController

@synthesize inappButton;
@synthesize scrollView;
@synthesize versionLabel;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGFloat scrollX = 0.0;
	CGFloat scrollY = 44.0;
	CGFloat scrollWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat scrollHeight = [UIScreen mainScreen].bounds.size.height - 44.0;
	[scrollView setFrame:CGRectMake(scrollX, scrollY, scrollWidth, scrollHeight)];
	scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 520.0);
	[self.view addSubview:scrollView];
	
	versionLabel.text = [NSString stringWithFormat:@"Versión %@",
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(productPurchased:)
												 name:kProductPurchasedNotification
											   object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector: @selector(productPurchaseFailed:)
												 name:kProductPurchaseFailedNotification
											   object: nil];
	
	[inappButton setTitle:@"Comprar Loteria Premium" forState:UIControlStateNormal];
	inappButton.enabled = NO;
	
	// Setup Button to handle In-App Purchases
	if ([[InAppPurchaseObserver sharedInAppPurchase] isPremium]) {
		[inappButton setTitle:@"Loteria Premium" forState:UIControlStateNormal];
		inappButton.enabled = NO;
	} else {
		[[InAppPurchaseObserver sharedInAppPurchase] requestProducts];
		if ([[InAppPurchaseObserver sharedInAppPurchase] premiumAvailable]) {
			[inappButton setTitle:@"Comprar Loteria Premium" forState:UIControlStateNormal];
			inappButton.enabled = YES;
		} else {
			// Notify user that In-App Purchase is disabled via button text.
			[inappButton setTitle:@"Loteria Premium No Disponible" forState:UIControlStateNormal];
			inappButton.enabled = NO;
		}
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.inappButton = nil;
	self.scrollView = nil;
	self.versionLabel = nil;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchaseFailedNotification object:nil];
	[inappButton release];
	[scrollView release];
	[versionLabel release];
	[super dealloc];
}

#pragma mark -
#pragma mark Interface Builder Actions

- (IBAction)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)buyInApp:(id)sender {
	[[InAppPurchaseObserver sharedInAppPurchase] buyPremium];
}

- (IBAction)sendFeedback:(id)sender {
	[self displayComposerSheet];
}

- (IBAction)goToWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.riveralabs.com"]];
}

#pragma mark -
#pragma mark Custom Methods

- (void)displayComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSArray *toRecipients = [NSArray arrayWithObject:@"apps@riveralabs.com"];
	[picker setToRecipients:toRecipients];
	
	[picker setSubject:@"Loteria Puerto Rico Feedback"];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark -
#pragma mark Notification Methods

- (void)productPurchased:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[inappButton setTitle:@"Loteria Premium" forState:UIControlStateNormal];
	inappButton.enabled = NO;
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *)notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	NSString *errorString = nil;
	
	BOOL showAlert = NO;
	// Notifies users about errors associated with the interface
	switch (result)  {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			errorString = [NSString stringWithFormat:@"E-mail failed: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
		default:
			errorString = [NSString stringWithFormat:@"E-mail was not sent: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (showAlert == YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Error"
														message:errorString
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

@end
