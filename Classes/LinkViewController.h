//
//  LinkViewController.h
//  LotteryPR
//
//  Created by arn on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class Lottery;

@interface LinkViewController : UIViewController <UIActionSheetDelegate> {
	UIWebView *webView;
	UIBarButtonItem *actionButton;
	UIBarButtonItem *refreshButton;
	
	Lottery *activeLottery;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;

- (void)setActiveLottery:(Lottery *)lottery;

- (IBAction)reloadPage:(id)sender;

- (IBAction)openActions:(id)sender;

@end
