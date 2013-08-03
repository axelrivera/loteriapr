//
//  LinkViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LinkViewController.h"

@implementation LinkViewController

@synthesize webView;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.title = @"Premios";
	
	NSURL *url = [NSURL URLWithString:DefaultUrl];
	
	//URL Requst Object
	NSURLRequest *requestPage = [NSURLRequest requestWithURL:url
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:30];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestPage];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[webView loadHTMLString:@"" baseURL:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																						  target:self
																						  action:@selector(reloadPage:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																						   target:self
																						   action:@selector(openActions:)] autorelease];
}

- (void)viewDidUnload {
	webView.delegate = nil;
	[webView release];
	webView = nil;
	[actionButton release];
	actionButton = nil;
	[refreshButton release];
	refreshButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	webView.delegate = nil;
	[webView release];
	[actionButton release];
	[refreshButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Class Methods

#pragma mark -
#pragma mark Action Methods

- (void)reloadPage:(id)sender {
	[webView reload];
}

- (void)openActions:(id)sender {
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:webView.request.URL.absoluteString
															 delegate:self
													cancelButtonTitle:@"Cancelar"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Abrir en Safari", nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:self.tabBarController.tabBar]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark -
#pragma mark UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)aView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	webView.hidden = YES;
	actionButton.enabled = NO;
	refreshButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	webView.hidden = NO;
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:DefaultUrl];
		[[UIApplication sharedApplication] openURL:url];
	} else {
		//NSLog(@"cancel");
	}
}

@end
