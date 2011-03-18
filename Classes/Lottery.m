//
//  Lottery.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "Lottery.h"
#import "NSMutableArray+Shuffle.h"

@interface Lottery (Private)

+ (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax;

@end

@implementation Lottery

@synthesize gameName;
@synthesize drawDate;
@synthesize winningNumbers;

- (id)init {
	if ((self = [super init])) {
		self.gameName = @"";
		self.drawDate = [NSDate	date];
		playType = LotteryPlayTypeNone;
	}
	return self;
}

- (id)initWithName:(NSString *)name {
	self = [self init];
	if (self == nil) {
		return nil;
	}
	self.gameName = name;	
	return self;
}

- (id)initWithName:(NSString *)name date:(NSString *)dateString {
	self = [self initWithName:name];
	if (self == nil) {
		return nil;
	}
	self.drawDate = [self toDateFromString:dateString];
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	if ((self = [self init])) {
		// Initialization Code
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		[self setGameName:[decoder decodeObjectForKey:@"gameName"]];
		[self setDrawDate:[decoder decodeObjectForKey:@"drawDate"]];
		[self setWinningNumbers:[decoder decodeObjectForKey:@"winningNumbers"]];
		playType = [decoder decodeIntForKey:@"playType"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:gameName forKey:@"gameName"];
	[encoder encodeObject:drawDate forKey:@"drawDate"];
	[encoder encodeObject:winningNumbers forKey:@"winningNumbers"];
	[encoder encodeInt:playType forKey:@"playType"];
}

- (void)dealloc {
	[gameName release];
	[drawDate release];
	[winningNumbers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Class Methods

+ (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax {
	NSMutableArray *localArray = [[[NSMutableArray alloc] initWithCapacity:localMax] autorelease];
	for (NSInteger i = localMin; i <= localMax; i++) {
		[localArray addObject:[NSNumber numberWithInteger:i]]; 
	}
	return localArray;	
}

+ (NSArray *)lotteryBucket {
	return (NSArray *)[self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX];	
}

+ (NSArray *)lotoBucket {
	return (NSArray *)[self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX];	
}

+ (NSString *)stringForLotteryType:(LotteryPlayType)type {
	NSString *returnStr = nil;
	if (type == LotteryPlayTypeExact) {
			returnStr = @"Exacta";
	} else if (type == LotteryPlayTypeCombined) {
		returnStr = @"Combinada";
	} else if (type == LotteryPlayTypeExactCombined) {
		returnStr = @"Exacta/Combinada";
	} else {
		returnStr = @"";
	}
	return returnStr;
}

#pragma mark -
#pragma mark Custom Methods

- (NSMutableArray *)emptyNumbersWithMax:(int)max {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:max];
	for (int i = 0; i < max; i++) {
		[array addObject:[NSNumber numberWithInt:0]];
	}
	return array;
}

- (NSDate *)toDateFromString:(NSString *)dateString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[formatter setLocale: usLocale];
	[usLocale release];
	
	[formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
	
	NSDate *date = [formatter dateFromString: dateString];
	
	if (date == nil)
		date = [NSDate date];
	
	[formatter release];
	
	return date;
}

- (NSArray *)winningNumbersFromString:(NSString *)string withRange:(NSInteger)numRange {
	if ([string length] != numRange)
		[NSException raise:@"Invalid Winning Number String" format:@"For Game %@", gameName];
	
	NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:numRange];
	
	for (int i = 0; i < [string length]; i++) {
		unichar c = [string characterAtIndex:(NSUInteger)i];
		NSString *element = [NSString stringWithFormat:@"%C", c];
		[numbers addObject:[NSNumber numberWithInteger:element.integerValue]];
	}
	return numbers;
}

- (NSString *)numbersToString {
	return [winningNumbers componentsJoinedByString:@""];
}

- (NSString *)lotteryTypeToString {
	return [Lottery stringForLotteryType:playType];
}

- (void)setPlayType:(LotteryPlayType)type {
	playType = type;
}

- (LotteryPlayType)playType {
	return playType;
}

- (NSString *)description {
	if (self.winningNumbers != nil) {
		return [NSString stringWithFormat:@"Game Name: %@, Date: %@, Winning Numbers: %@",
				self.gameName, self.drawDate, [self numbersToString]];
	}
	return [super description];
}

@end
