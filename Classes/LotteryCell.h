//
//  LotteryCell.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class Lottery;
@class LotterySix;
@class LotteryFour;
@class LotteryThree;
@class LotteryTwo;
@class LotteryBallView;

@interface LotteryCell : UITableViewCell {
	UIImageView *logoView;
	UILabel *dateLabel;
	LotteryBallView *numbersView;
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) LotteryBallView *numbersView;

- (void)setLoto:(LotterySix *)lottery;
- (void)setRevancha:(LotterySix *)lottery;
- (void)setPegaCuatro:(LotteryFour *)lottery;
- (void)setPegaTres:(LotteryThree *)lottery;
- (void)setPegaDos:(LotteryTwo *)lottery;
- (void)setDateLabel:(NSDate *)date;

@end
