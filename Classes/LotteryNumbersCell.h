//
//  LotteryNumbersCell.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class LotteryBallView;

@interface LotteryNumbersCell : UITableViewCell {
	LotteryBallView *numbersView;
}

@property (nonatomic, retain) LotteryBallView *numbersView;

@end
