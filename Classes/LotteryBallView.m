//
//  LoteryBallView.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "LotteryBallView.h"
#import "LotteryBall.h"

@implementation LotteryBallView

@synthesize ballViews;
@synthesize lotteryType;
@synthesize ballColor;

- (id)initWithType:(LotteryType)type ballColor:(LotteryBallColorType)color {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		self.lotteryType = type;
		self.ballColor  = color;
		[self setupBallViews];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 1;
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat positionY = 0.0;
	CGFloat positionX = 0.0;
	
	for (NSInteger i = 0; i < [ballViews count]; i++) {
		if (i > 0) {
			positionX = positionX + LOTTERY_BALL_OFFSET	+ LOTTERY_BALL_SIZE;
		}
		[[ballViews objectAtIndex:i] setFrame:CGRectMake(positionX, positionY, LOTTERY_BALL_SIZE, LOTTERY_BALL_SIZE)];
	}	
}

- (void)setBallViewWithNumbers:(NSArray *)numbers {
	[self setBallViewWithNumbers:numbers andHits:[NSArray array] hitColor:self.ballColor];
}

- (void)setBallViewWithNumbers:(NSArray *)numbers andHits:(NSArray *)hits hitColor:(LotteryBallColorType)color {
	if ([self totalBallViews] == [numbers count]) {
		NSDictionary *myHits = [NSDictionary dictionaryWithObjects:hits forKeys:hits];	
		for (NSInteger i = 0; i < [numbers count]; i++) {
			LotteryBall *ball = [self.ballViews objectAtIndex:i];
			if ([myHits count] > 0 && [myHits objectForKey:[numbers objectAtIndex:i]] != nil) {
				[ball setBallColor:color];
			} else {
				[ball setBallColor:self.ballColor];
			}
			ball.text = [NSString stringWithFormat:@"%d", [[numbers objectAtIndex:i] integerValue]];
		}
	}
}

- (void)setLotteryType:(LotteryType)type {
	lotteryType = type;
	[self setupBallViews];
	
}

- (void)setBallColor:(LotteryBallColorType)color {
	ballColor = color;
	for (NSInteger i = 0; i < [self totalBallViews]; i++) {
		LotteryBall *ball = [self.ballViews objectAtIndex:i];
		[ball setBallColor:color];
	}
}

- (void)setupBallViews {
	NSInteger ballCount;
	if (self.lotteryType == LotteryTypeSix) {
		ballCount = 6;
	} else if (self.lotteryType == LotteryTypeFour) {
		ballCount = 4;
	} else if (self.lotteryType == LotteryTypeThree) {
		ballCount = 3;
	} else if (self.lotteryType == LotteryTypeTwo) {
		ballCount = 2;
	} else {
		ballCount = 0;
	}
	
	if (ballViews != nil) {
		for (NSInteger i = 0; i < [ballViews count]; i++) {
			[[ballViews objectAtIndex:i] removeFromSuperview];
		}
		[ballViews release];
	}
	
	NSMutableArray *tmpBalls = [[NSMutableArray alloc] initWithCapacity:ballCount];
	for (NSInteger i = 0; i < ballCount; i++) {
		LotteryBall *ball = [[LotteryBall alloc] initWithColor:self.ballColor];
		[self addSubview:ball];
		[tmpBalls addObject:ball];
		[ball release];
	}
	
	ballViews = [[NSArray alloc] initWithArray:tmpBalls];
	[tmpBalls release];
	CGFloat viewHeight = LOTTERY_BALL_SIZE;
	CGFloat viewWidth = (LOTTERY_BALL_SIZE * [self totalBallViews]) + (([self totalBallViews] - 1) * LOTTERY_BALL_OFFSET);
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, viewWidth, viewHeight)];
}

- (NSInteger)totalBallViews {
	return [ballViews count];
}

- (void)dealloc {
	[ballViews release];
    [super dealloc];
}


@end
