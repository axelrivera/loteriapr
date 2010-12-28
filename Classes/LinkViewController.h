//
//  LinkViewController.h
//  LotteryPR
//
//  Created by arn on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class Lottery;

@interface LinkViewController : UIViewController {
	UIWebView *webView;
	Lottery *activeLottery;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void)setActiveLottery:(Lottery *)lottery;

- (IBAction)reloadPage:(id)sender;

- (IBAction)openActions:(id)sender;

@end
