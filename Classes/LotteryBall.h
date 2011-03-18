//
//  LotteryBall.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

typedef enum { LotteryBallColorWhite, LotteryBallColorMagenta, LotteryBallColorSalmon, LotteryBallColorBlue, LotteryBallColorRed, LotteryBallColorOrange, LotteryBallColorYellow } LotteryBallColorType;

@interface LotteryBall : UIView {
	UIImageView *ballBackground;
	UILabel *ballLabel;
	NSString *text;
	LotteryBallColorType ballColor;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic) LotteryBallColorType ballColor;

- (id)initWithColor:(LotteryBallColorType)color;
- (id)initWithColor:(LotteryBallColorType)color text:(NSString *)txt;
- (void)setBallColor:(LotteryBallColorType)color;
- (NSString *)colorFileName;

@end
