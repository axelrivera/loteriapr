//
//  VerifyViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class Lottery;
@class LotteryData;
@class VerifyCell;

@interface VerifyViewController : UIViewController {
	UISegmentedControl *segmentedControl;
	UITableView *numbersTable;
	LotteryData *lotteryData;
	NSMutableArray *currentArray;
	NSMutableArray *lotoArray;
	NSMutableArray *revanchaArray;
	NSMutableArray *pegaCuatroArray;
	NSMutableArray *pegaTresArray;
	NSMutableArray *pegaDosArray;
}

@property (nonatomic, retain) IBOutlet UITableView *numbersTable;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSMutableArray *lotoArray;
@property (nonatomic, copy) NSMutableArray *revanchaArray;
@property (nonatomic, copy) NSMutableArray *pegaCuatroArray;
@property (nonatomic, copy) NSMutableArray *pegaTresArray;
@property (nonatomic, copy) NSMutableArray *pegaDosArray;

- (void)verifyNumbers;
- (BOOL)numbers:(NSArray *)numbers haveExactPrizeFor:(NSArray *)winning;
- (BOOL)numbers:(NSArray *)numbers haveCombinedPrizeFor:(NSArray *)winning;
- (int)validateWinning:(NSArray *)winning withLottery:(Lottery *)lottery;

@end
