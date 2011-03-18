//
//  LotteryThree.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryThree.h"
#import "NSMutableArray+Shuffle.h"

@implementation LotteryThree

- (id)init {
	if ((self = [super init])) {	
		self.winningNumbers = [self emptyNumbersWithMax:PEGA_TRES_RANGE];
		playType = LotteryPlayTypeExact;
	}
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	self = [self initWithName:name date:dateString];
	if (self == nil) {
		return nil;
	}
	self.winningNumbers = [NSArray arrayWithArray:[self winningNumbersFromString:numberString withRange:(NSInteger)PEGA_TRES_RANGE]];
	return self;
}

#pragma mark -
#pragma mark Custom Class Methods

+ (LotteryThree *)random {
	NSMutableArray *bucket = [NSMutableArray arrayWithArray:[self lotteryBucket]];
	NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:1];
	
	[bucket shuffleWithCount:SHUFFLE_COUNT];
	
	for (NSInteger i = 0; i < PEGA_TRES_RANGE; i++) {
		[random addObject:[bucket objectAtIndex:i]];
	}
	
	LotteryThree *lotteryThree = [[[LotteryThree alloc] init] autorelease];
	[lotteryThree setGameName:PegaTresTitle];
	[lotteryThree setWinningNumbers:(NSArray *)random];
	[random release];
	return lotteryThree;
}

@end
