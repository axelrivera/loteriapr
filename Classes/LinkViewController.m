//
//  LinkViewController.m
//  LotteryPR
//
//  Created by arn on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LinkViewController.h"
#import "Lottery.h"

@implementation LinkViewController

@synthesize webView;
@synthesize actionButton;
@synthesize refreshButton;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.title = [activeLottery gameName];
	
	NSURL *url = nil;
	if ([LotoTitle isEqualToString:[activeLottery gameName]]) {
		url = [NSURL URLWithString:LotoUrl];
	} else if ([RevanchaTitle isEqualToString:[activeLottery gameName]]) {
		url = [NSURL URLWithString:RevanchaUrl];
	} else if ([PegaCuatroTitle isEqualToString:[activeLottery gameName]]) {
		url = [NSURL URLWithString:PegaCuatroUrl];
	} else if ([PegaTresTitle isEqualToString:[activeLottery gameName]]) {
		url = [NSURL URLWithString:PegaTresUrl];
	} else if ([PegaDosTitle isEqualToString:[activeLottery gameName]]) {
		url = [NSURL URLWithString:PegaDosUrl];
	} else {
		url = [NSURL URLWithString:DefaultUrl];
	}
		
	//URL Requst Object
	NSURLRequest *requestPage = [NSURLRequest requestWithURL:url 
												 cachePolicy:NSURLRequestUseProtocolCachePolicy 
											 timeoutInterval:30];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestPage];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)setActiveLottery:(Lottery *)lottery {
	activeLottery = lottery;
}

- (IBAction)reloadPage:(id)sender {
	[webView reload];
}

- (IBAction)openActions:(id)sender {
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:webView.request.URL.absoluteString
															 delegate:self
													cancelButtonTitle:@"Cancelar"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Abrir en Safari", nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];}

- (void)webViewDidStartLoad:(UIWebView *)aView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	actionButton.enabled = NO;
	refreshButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	actionButton.enabled = YES;
	refreshButton.enabled = YES;
}

- (void)webView:(UIWebView *)aView didFailLoadWithError:(NSError *)error {
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", 
                             [error localizedDescription]]; 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
													message:errorString
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];	
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:webView.request.URL.absoluteString]];
	} else {
		//NSLog(@"cancel");
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
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


@end
