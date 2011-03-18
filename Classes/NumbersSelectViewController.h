//
//  NumbersSelectViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class Lottery;
@class LotteryBallView;

@interface NumbersSelectViewController : UIViewController {
	UILabel *descriptionLabel;
	Lottery *currentLottery;
	LotteryBallView *lotteryBallView;
}

@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

- (void)setCurrentLottery:(Lottery *)lottery;

@end
