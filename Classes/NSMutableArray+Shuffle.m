//
//  NSMutableArray+Shuffle.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@implementation NSMutableArray (NSMutableArrayFunctions)

- (void)shuffle {
	NSUInteger count = [self count];
	for (NSUInteger i = 0; i < count; ++i) {
		int nElements = count - i;
		int n = (arc4random() % nElements) + i;
		[self exchangeObjectAtIndex:i withObjectAtIndex:n];
	}
}

- (void)shuffleWithCount:(NSInteger)count {
	for (int i = 0; i < count; i++) {
		[self shuffle];
	}
}

@end
