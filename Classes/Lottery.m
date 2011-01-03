//
//  Lottery.m
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Lottery.h"

@implementation Lottery

@synthesize gameName;
@synthesize drawDate;
@synthesize winningNumbers;

- (id)init {
	if (self = [super init]) {
		self.gameName = @"";
		self.drawDate = [NSDate	date];
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
	if (self = [self init]) {
		// Initialization Code
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		[self setGameName:[decoder decodeObjectForKey:@"gameName"]];
		[self setDrawDate:[decoder decodeObjectForKey:@"drawDate"]];
		[self setWinningNumbers:[decoder decodeObjectForKey:@"winningNumbers"]];	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:gameName forKey:@"gameName"];
	[encoder encodeObject:drawDate forKey:@"drawDate"];
	[encoder encodeObject:winningNumbers forKey:@"winningNumbers"];
}


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

- (void)dealloc {
	[gameName release];
	[drawDate release];
	[winningNumbers release];
    [super dealloc];
}

@end
