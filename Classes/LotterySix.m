//
//  LotterySix.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotterySix.h"
#import "NSMutableArray+Shuffle.h"

@implementation LotterySix

@synthesize bonusPlay;

- (id)init {
	if ((self = [super init])) {	
		self.winningNumbers = [self emptyNumbersWithMax:LOTO_RANGE];
		self.bonusPlay = NO;
	}
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	// Call the superclass's designated initializer 
	self = [self initWithName:name date:dateString];
	// Did the superclass's initialization fail? 
	if (self == nil) {
		return nil;
	}
	self.winningNumbers = [NSArray arrayWithArray:[self winningNumbersFromString:numberString withRange:(NSInteger)LOTO_RANGE]];
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder])) {
		[self setBonusPlay:[decoder decodeBoolForKey:@"bonusPlay"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];  // add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeBool:bonusPlay forKey:@"bonusPlay"];
}


#pragma mark -
#pragma mark Custom Class Methods

+ (NSArray *)orderedArrayFromNumbers:(NSArray *)numbers {
	NSArray *sortedArray = [numbers sortedArrayUsingComparator: ^(id obj1, id obj2) {
		if ([obj1 integerValue] > [obj2 integerValue]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		if ([obj1 integerValue] < [obj2 integerValue]) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
	return sortedArray;
}

+ (LotterySix *)random {
	NSMutableArray *bucket = [NSMutableArray arrayWithArray:[self lotoBucket]];
	NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:1];
	
	[bucket shuffleWithCount:SHUFFLE_COUNT];
	
	for (NSInteger i = 0; i < LOTO_RANGE; i++) {
		[random addObject:[bucket objectAtIndex:i]];
	}
	
	LotterySix *lotterySix = [[[LotterySix alloc] init] autorelease];
	[lotterySix setGameName:LotoTitle];
	[lotterySix setWinningNumbers:[self orderedArrayFromNumbers:(NSArray *)random]];
	[random release];
	return lotterySix;
}

+ (BOOL)isValidForNumbers:(NSArray *)numbers {
	BOOL inSet = NO;
	NSSet *numberSet = [[NSSet alloc] initWithArray:numbers
						];
	if ([numbers count] == [numberSet count]) {
		inSet = YES;
	}
	[numberSet release];
	return inSet;
}

#pragma mark -
#pragma mark Custom Methods

// Number String should be in the format XX-XX-XX-XX-XX-XX
- (NSArray *)winningNumbersFromString:(NSString *)string withRange:(NSInteger)numRange {
	NSArray *stringArray = [string componentsSeparatedByString:@"-"];
	if ([stringArray count] != numRange)
		[NSException raise:@"Invalid Winning Number String" format:@"Should be: XX-XX-XX-XX-XX-XX"];
	
	NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:numRange];
	
	for (NSString *element in stringArray) {
		[numbers addObject:[NSNumber numberWithInteger:element.integerValue]];
	}
	return numbers;
}

- (NSString *)numbersToString {
	return [winningNumbers componentsJoinedByString:@"-"];
}

- (NSString *)bonusPlayString {
	NSString *returnStr = nil;
	if (self.bonusPlay == YES) {
		returnStr = @"Con Revancha";
	} else {
		returnStr = @"Sin Revancha";
	}
	return returnStr;
}

- (NSArray *)hitsForNumbers:(NSArray *)numbers {
	// Numbers Should Be the Official Numbers from Loteria Electronica
	NSDictionary *myNumbers = [NSDictionary dictionaryWithObjects:self.winningNumbers forKeys:self.winningNumbers];
	NSDictionary *lotteryNumbers = [NSDictionary dictionaryWithObjects:numbers forKeys:numbers];
	NSMutableArray *hitsArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
	
	NSEnumerator *enumerator = [lotteryNumbers keyEnumerator];
	id aNumber = nil;
	while ((aNumber = [enumerator nextObject]) != nil) {
		if ([myNumbers objectForKey:aNumber] != nil) {
			[hitsArray addObject:aNumber];
		}
	}
	return (NSArray *)hitsArray;
}

- (NSString *)description {
	if (self.winningNumbers != nil) {
		return [NSString stringWithFormat:@"Game Name: %@, Date: %@, Winning Numbers: %@",
				self.gameName, self.drawDate, [self numbersToString]];
	}
	return [super description];
}

@end
