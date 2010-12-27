//
//  LotterySix.m
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LotteryTwo.h"

#define NUMBER_RANGE 2

@implementation LotteryTwo

- (id)init {
	if (self = [super init]) {	
		self.winningNumbers = [self emptyNumbersWithMax:NUMBER_RANGE];
	}
	return self;
}

- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString {
	self = [self initWithName:name date:dateString];
	if (self == nil) {
		return nil;
	}
	self.winningNumbers = [NSArray arrayWithArray:[self winningNumbersFromString:numberString withRange:(NSInteger)NUMBER_RANGE]];
	return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
