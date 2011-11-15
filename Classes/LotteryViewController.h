//
//  LotteryViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "NumberLoader.h"
#import "PrizeLoader.h"

@class LinkViewController;
@class NumbersViewController;

@interface LotteryViewController : UIViewController <NumberLoaderDelegate, PrizeLoaderDelegate> {
	LinkViewController *linkViewController;
	NumbersViewController *numbersViewController;
    NumberLoader *numberLoader_;
    PrizeLoader *prizeLoader_;
    
	
//	BOOL waitingForItemTitle;
//	BOOL waitingForItemDate;
//	
//	NSMutableDictionary *lotteryNumbers;
//    NSMutableData *xmlData; 
//	NSURLConnection *connectionInProgress;
//	
//	NSMutableString *tmpString;
//	NSMutableString *titleString;
//	NSMutableString *dateString;
}

@property (nonatomic, retain) IBOutlet UITableView *lotteryTable;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UILabel *lotoPrizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *revanchaPrizeLabel;
@property (nonatomic, retain) NSDictionary *lotteryNumbers;

- (void)loadNumbers;
- (void)loadAbout;

- (void)showLoadingButtonItem;
- (void)showRefreshButtonItem;
- (void)showInfoButtonItem;

@end
