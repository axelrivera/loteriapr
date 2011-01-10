//
//  Lottery.h
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@interface Lottery : NSObject {
	NSString *gameName;
	NSDate *drawDate;
	NSArray *winningNumbers;
}

@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSDate *drawDate;
@property (nonatomic, copy) NSArray *winningNumbers;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name date:(NSString *)dateString;
- (id)initWithName:(NSString *)name numbers:(NSString *)numberString date:(NSString *)dateString;

- (NSMutableArray *)emptyNumbersWithMax:(int)max;
- (NSDate *)toDateFromString:(NSString *)dateString;
- (NSArray *)winningNumbersFromString:(NSString *)string withRange:(NSInteger)numRange;
- (NSString *)numbersToString;

@end
