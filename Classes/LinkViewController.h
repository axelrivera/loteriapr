//
//  LinkViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
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
