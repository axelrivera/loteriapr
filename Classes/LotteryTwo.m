//
//  LotteryTwo.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryTwo.h"
#import "NSMutableArray+Shuffle.h"

@implementation LotteryTwo

- (id)init {
	if ((self = [super init])) {	
		self.winningNumbers = [self emptyNumbersWithMax:PEGA_DOS_RANGE];
		self.playType = LotteryPlayTypeExact;
	}
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	self = [self initWithName:name date:dateString];
	if (self == nil) {
		return nil;
	}
	self.winningNumbers = [NSArray arrayWithArray:[self winningNumbersFromString:numberString withRange:(NSInteger)PEGA_DOS_RANGE]];
	return self;
}

#pragma mark -
#pragma mark Custom Class Methods

+ (LotteryTwo *)random {
	NSMutableArray *bucket = [NSMutableArray arrayWithArray:[self lotteryBucket]];
	NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:1];
	
	[bucket shuffleWithCount:SHUFFLE_COUNT];
	
	for (NSInteger i = 0; i < PEGA_DOS_RANGE; i++) {
		[random addObject:[bucket objectAtIndex:i]];
	}
	
	LotteryTwo *lotteryTwo = [[[LotteryTwo alloc] init] autorelease];
	[lotteryTwo setGameName:PegaDosTitle];
	[lotteryTwo setWinningNumbers:(NSArray *)random];
	[random release];
	return lotteryTwo;
}

@end
