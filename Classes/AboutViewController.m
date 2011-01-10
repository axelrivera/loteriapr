//
//  AboutViewController.m
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Interface Builder Actions

- (IBAction)goToWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.riveralabs.com"]];
}

@end
