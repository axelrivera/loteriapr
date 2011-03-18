//
//  NumbersViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class LotteryData;
@class NumbersSelectViewController;
@class EditNumberViewController;

@interface NumbersViewController : UIViewController {
	NumbersSelectViewController *numbersSelectViewController;
	EditNumberViewController *editNumberViewController;
	
	UISegmentedControl *lotteryControl;
	UITableView *numbersTable;
	LotteryData *lotteryData;
	NSMutableArray *currentNumbers;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *lotteryControl;
@property (nonatomic, retain) IBOutlet UITableView *numbersTable;

- (IBAction)addNumber:(id)sender;
- (IBAction)controlAction:(id)sender;
- (void)showAddButton;
- (void)showRemoveButton;
- (void)removeAllFromCurrent;
- (void)showFreeAlert;
- (void)showPremiumAlert;

@end
