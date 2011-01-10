//
//  LotterySix.m
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotterySix.h"

@implementation LotterySix

- (id)init {
	if (self = [super init]) {	
		self.winningNumbers = [self emptyNumbersWithMax:LOTO_RANGE];
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

#pragma mark -
#pragma mark Class Methods

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

@end
