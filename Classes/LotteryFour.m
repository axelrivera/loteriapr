//
//  LotteryFour.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryFour.h"
#import "NSMutableArray+Shuffle.h"

@implementation LotteryFour

- (id)init {
	if ((self = [super init])) {	
		self.winningNumbers = [self emptyNumbersWithMax:PEGA_CUATRO_RANGE];
		playType = LotteryPlayTypeExact;
	}
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	self = [self initWithName:name date:dateString];
	if (self == nil) {
		return nil;
	}
	self.winningNumbers = [NSArray arrayWithArray:[self winningNumbersFromString:numberString withRange:(NSInteger)PEGA_CUATRO_RANGE]];
	return self;
}

#pragma mark -
#pragma mark Custom Class Methods

+ (LotteryFour *)random {
	NSMutableArray *bucket = [NSMutableArray arrayWithArray:[self lotteryBucket]];
	NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:1];
	
	[bucket shuffleWithCount:SHUFFLE_COUNT];
	
	for (NSInteger i = 0; i < PEGA_CUATRO_RANGE; i++) {
		[random addObject:[bucket objectAtIndex:i]];
	}
	
	LotteryFour *lotteryFour = [[[LotteryFour alloc] init] autorelease];
	[lotteryFour setGameName:PegaCuatroTitle];
	[lotteryFour setWinningNumbers:(NSArray *)random];
	[random release];
	return lotteryFour;
}

@end
