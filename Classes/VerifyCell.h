//
//  VerifyCell.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class LotteryData;
@class LotteryBallView;
@class LotteryBall;

@interface VerifyCell : UITableViewCell {
	UIImageView *logoView;
	UILabel *dateLabel;
	UILabel *updateLabel;
	LotteryBallView *numbersView;
	NSDateFormatter *dateFormatter;
	LotteryData *lotteryData;
}

@property (nonatomic, retain) LotteryBallView *numbersView;

- (void)setLoto;
- (void)setRevancha;
- (void)setPegaCuatro;
- (void)setPegaTres;
- (void)setPegaDos;
- (void)setDateLabel:(NSDate *)date;
- (void)setUpdateLabel:(NSDate *)date;

@end
