//
//  LotteryBall.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "LotteryBall.h"

@implementation LotteryBall

@synthesize text;
@synthesize ballColor;

- (id)initWithColor:(LotteryBallColorType)color {
	self = [self initWithColor:color text:@""];
	return self;
}

- (id)initWithColor:(LotteryBallColorType)color text:(NSString *)txt {
	CGRect sizeRect = CGRectMake(0.0, 0.0, LOTTERY_BALL_SIZE, LOTTERY_BALL_SIZE);
	self = [self initWithFrame:sizeRect];
	if (self) {
		self.ballColor = color;
		ballBackground = [[UIImageView alloc] initWithFrame:sizeRect];
		[self addSubview:ballBackground];
		
		ballLabel = [[UILabel alloc] initWithFrame:sizeRect];
		ballLabel.textAlignment = UITextAlignmentCenter;
		ballLabel.shadowOffset = CGSizeMake(0, 1);
		ballLabel.backgroundColor = [UIColor clearColor];
		ballLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
		
		self.text = txt;
		
		[ballBackground addSubview:ballLabel];
		
        [ballBackground setContentMode:UIViewContentModeTopLeft];
		[self setBallColor:self.ballColor];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)setBallColor:(LotteryBallColorType)color {
	ballColor = color;
	[ballBackground setImage:[UIImage imageNamed:[self colorFileName]]];
}

- (void)setLabelColor {
	NSSet *whiteSet = [NSSet setWithObjects:
					   [NSNumber numberWithInt:LotteryBallColorMagenta],
					   [NSNumber numberWithInt:LotteryBallColorSalmon],
					   [NSNumber numberWithInt:LotteryBallColorBlue],
					   [NSNumber numberWithInt:LotteryBallColorRed],
					   [NSNumber numberWithInt:LotteryBallColorOrange],
					   nil];
	
	if ([whiteSet containsObject:[NSNumber numberWithInt:self.ballColor]] == YES) {
		ballLabel.textColor = [UIColor whiteColor];
		ballLabel.shadowColor = [UIColor blackColor];
	} else {
		ballLabel.textColor = [UIColor blackColor];
		ballLabel.shadowColor = [UIColor whiteColor];
	}
}

- (NSString *)colorFileName {
	NSString *colorString = nil;
	if (self.ballColor == LotteryBallColorMagenta) {
		colorString = [NSString stringWithFormat:@"magenta_ball.png"];
	} else if (self.ballColor == LotteryBallColorSalmon) {
		colorString = [NSString stringWithFormat:@"salmon_ball.png"];
	} else if (self.ballColor == LotteryBallColorBlue) {
		colorString = [NSString stringWithFormat:@"blue_ball.png"];
	} else if (self.ballColor == LotteryBallColorRed) {
		colorString = [NSString stringWithFormat:@"red_ball.png"];
	} else if (self.ballColor == LotteryBallColorOrange) {
		colorString = [NSString stringWithFormat:@"orange_ball.png"];
	} else if (self.ballColor == LotteryBallColorYellow) {
		colorString = [NSString stringWithFormat:@"yellow_ball.png"];
	} else {
		colorString = [NSString stringWithFormat:@"white_ball.png"];
	}
	return colorString;
}

- (void)setText:(NSString *)txt {
	if (text != nil)
		[text release];
	
	text = [[NSString alloc] initWithString:txt];
	ballLabel.text = text;
	[self setLabelColor];
}

- (void)dealloc {
	[ballBackground release];
	[ballLabel release];
	[text release];
    [super dealloc];
}

@end
