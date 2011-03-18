//
//  EditNumberViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class Lottery;
@class LotteryBallView;

@interface EditNumberViewController : UIViewController {
	UITableView *lotteryTable;
	UISwitch *playSwitch;
	NSString *currentGame;
	NSString *playType;
	Lottery *currentLottery;
	LotteryBallView *lotteryBallView;
	BOOL start;
}

@property (nonatomic, retain) IBOutlet UITableView *lotteryTable;
@property (nonatomic, retain) UISwitch *playSwitch;
@property (nonatomic) BOOL start;

- (void)setCurrentLottery:(Lottery *)lottery;
- (void)setCurrentGame:(NSString *)game;
- (void)setPlayType:(NSString *)type;
- (void)saveNumber;


@end
