//
//  LotterySix.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "Lottery.h"

@interface LotterySix : Lottery {
	BOOL bonusPlay;
}

@property (nonatomic) BOOL bonusPlay;

+ (NSArray *)orderedArrayFromNumbers:(NSArray *)numbers;
+ (LotterySix *)random;
+ (BOOL)isValidForNumbers:(NSArray *)numbers;

- (NSString *)bonusPlayString;
- (NSArray *)hitsForNumbers:(NSArray *)numbers;

@end
