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
	NSURLRequest *requestPage = [NSURLRequest requestWithURL:url];
	
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
	NSLog(@"Open Actions");
}

- (void)webViewDidFinishLoad:(UIWebView *)aView {
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	webView.delegate = nil;
	[webView release];
    [super dealloc];
}


@end
