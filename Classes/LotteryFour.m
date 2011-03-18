//
//  LotterySix.m
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryFour.h"

@implementation LotteryFour

- (id)init {
	if (self = [super init]) {	
		self.winningNumbers = [self emptyNumbersWithMax:PEGA_CUATRO_RANGE];
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

@end
