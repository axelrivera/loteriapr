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

@interface LotteryViewController : UIViewController <NumberLoaderDelegate> {
	LinkViewController *linkViewController;
	NumbersViewController *numbersViewController;
    NumberLoader *numberLoader_;
}

@property (nonatomic, retain) IBOutlet UITableView *lotteryTable;
@property (nonatomic, retain) NSDictionary *lotteryNumbers;

- (void)loadNumbers;
- (void)loadAbout;

- (void)showLoadingButtonItem;
- (void)showRefreshButtonItem;
- (void)showInfoButtonItem;

@end
