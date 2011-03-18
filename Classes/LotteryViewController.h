//
//  LotteryViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@class LinkViewController;
@class NumbersViewController;

@interface LotteryViewController : UITableViewController <NSXMLParserDelegate> {
	LinkViewController *linkViewController;
	NumbersViewController *numbersViewController;
	
	BOOL waitingForItemTitle;
	BOOL waitingForItemDate;
	
	NSMutableDictionary *lotteryNumbers;
    NSMutableData *xmlData; 
	NSURLConnection *connectionInProgress;
	
	NSMutableString *tmpString;
	NSMutableString *titleString;
	NSMutableString *dateString;
}

@property (nonatomic, retain) NSMutableDictionary *lotteryNumbers;

- (void)loadNumbers;
- (void)loadAbout;

- (void)showLoadingButtonItem;
- (void)showRefreshButtonItem;
- (void)showInfoButtonItem;

@end
