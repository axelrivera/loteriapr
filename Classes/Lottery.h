//
//  Lottery.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

typedef enum { LotteryPlayTypeNone, LotteryPlayTypeExact, LotteryPlayTypeCombined, LotteryPlayTypeExactCombined } LotteryPlayType;

@interface Lottery : NSObject <NSCoding> {
	NSString *gameName;
	NSDate *drawDate;
	NSArray *winningNumbers;
	LotteryPlayType playType;
}

@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSDate *drawDate;
@property (nonatomic, copy) NSArray *winningNumbers;

// Class Methods

+ (NSArray *)lotteryBucket;
+ (NSArray *)lotoBucket;
+ (NSString *)stringForLotteryType:(LotteryPlayType)type;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name date:(NSString *)dateString;
- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString;

- (NSMutableArray *)emptyNumbersWithMax:(int)max;
- (NSDate *)toDateFromString:(NSString *)dateString;
- (NSArray *)winningNumbersFromString:(NSString *)string withRange:(NSInteger)numRange;
- (NSString *)numbersToString;
- (NSString *)lotteryTypeToString;
- (void)setPlayType:(LotteryPlayType)type;
- (LotteryPlayType)playType;

@end
