//
//  LoteryBallView.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class LotteryBall;

typedef enum { LotteryTypeNone, LotteryTypeSix, LotteryTypeFour, LotteryTypeThree, LotteryTypeTwo } LotteryType;

@interface LotteryBallView : UIView {
	LotteryType lotteryType;
	LotteryBallColorType ballColor;
	NSArray *ballViews;
}

@property (nonatomic, copy, readonly) NSArray *ballViews;
@property (nonatomic) LotteryType lotteryType;
@property (nonatomic) LotteryBallColorType ballColor;

- (id)initWithType:(LotteryType)type ballColor:(LotteryBallColorType)color;
- (void)setBallViewWithNumbers:(NSArray *)numbers;
- (void)setBallViewWithNumbers:(NSArray *)numbers andHits:(NSArray *)hits hitColor:(LotteryBallColorType)color;
- (void)setupBallViews;
- (NSInteger)totalBallViews;

@end
