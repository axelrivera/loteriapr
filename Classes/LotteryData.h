//
//  LotteryData.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class Lottery;
@class LotterySix;
@class LotteryFour;
@class LotteryThree;
@class LotteryTwo;

@interface LotteryData : NSObject <NSCoding> {
	NSMutableDictionary *latestNumbers;
	NSDate *latestUpdate;
	NSMutableArray *lotoNumbers;
	NSMutableArray *pegaCuatroNumbers;
	NSMutableArray *pegaTresNumbers;
	NSMutableArray *pegaDosNumbers;
}

@property (nonatomic, copy) NSMutableDictionary *latestNumbers;
@property (retain) NSDate *latestUpdate;
@property (nonatomic, copy, readonly) NSMutableArray *lotoNumbers;
@property (nonatomic, copy, readonly) NSMutableArray *pegaCuatroNumbers;
@property (nonatomic, copy, readonly) NSMutableArray *pegaTresNumbers;
@property (nonatomic, copy, readonly) NSMutableArray *pegaDosNumbers;

// Singleton Methods

+ (LotteryData *)sharedLotteryData;

// Custom Methods
- (id)initWithRandom;

- (void)addLotoObject:(LotterySix *)object;
- (void)addPegaCuatroObject:(LotteryFour *)object;
- (void)addPegaTresObject:(LotteryThree *)object;
- (void)addPegaDosObject:(LotteryTwo *)object;

- (void)removeLotoObjectAtIndex:(NSInteger)index;
- (void)removePegaCuatroObjectAtIndex:(NSInteger)index;
- (void)removePegaTresObjectAtIndex:(NSInteger)index;
- (void)removePegaDosObjectAtIndex:(NSInteger)index;

- (NSInteger)totalLotteryNumbers;
- (void)updateLatestNumbersWithDictionary:(NSMutableDictionary *)dictionary;
- (BOOL)canAddNumbers;

@end
