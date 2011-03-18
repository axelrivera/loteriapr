//
//  LotteryData.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "LotteryData.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "InAppPurchaseObserver.h"

static LotteryData *sharedLotteryData;

@implementation LotteryData

@synthesize latestNumbers;
@synthesize latestUpdate;
@synthesize lotoNumbers;
@synthesize pegaCuatroNumbers;
@synthesize pegaTresNumbers;
@synthesize pegaDosNumbers;

- (id)init {
	if ((self = [super init])) {
		LotterySix *loto = [[LotterySix alloc] initWithName:LotoTitle];
		LotterySix *revancha = [[LotterySix alloc] initWithName:RevanchaTitle];
		LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:PegaCuatroTitle];
		LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:PegaTresTitle];
		LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:PegaDosTitle];
		
		[self setLatestNumbers:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								loto, LotoKey,
								revancha, RevanchaKey,
								pegaCuatro, PegaCuatroKey,
								pegaTres, PegaTresKey,
								pegaDos, PegaDosKey,
								nil]];
		
		[loto release];
		[revancha release];
		[pegaCuatro release];
		[pegaTres release];
		[pegaDos release];
		
		[self setLatestUpdate:[NSDate date]];
		lotoNumbers = [[NSMutableArray alloc] init];
		pegaCuatroNumbers = [[NSMutableArray alloc] init];
		pegaTresNumbers = [[NSMutableArray alloc] init];
		pegaDosNumbers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithRandom {
	if ((self = [self init])) {
		int n = 100;
		//n = (arc4random() % 10) + 1;
		for (int i = 0; i < n; i++) {
			LotterySix *six = [LotterySix random];
			[six setBonusPlay:YES];
			[self addLotoObject:six];
		}
		//n = (arc4random() % 10) + 1;
		for (int i = 0; i < n; i++) {
			LotteryFour *four = [LotteryFour random];
			[self addPegaCuatroObject:four];
		}
		//n = (arc4random() % 10) + 1;
		for (int i = 0; i < n; i++) {
			LotteryThree *three = [LotteryThree random];
			[self addPegaTresObject:three];
		}
		//n = (arc4random() % 10) + 1;
		for (int i = 0; i < n; i++) {
			LotteryTwo *two = [LotteryTwo random];
			[self addPegaDosObject:two];
		}
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) { // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
		[self setLatestNumbers:[decoder decodeObjectForKey:@"latestNumbers"]];
		[self setLatestUpdate:[decoder decodeObjectForKey:@"latestUpdate"]];
		lotoNumbers = [[NSMutableArray alloc] initWithArray:[decoder decodeObjectForKey:@"lotoNumbers"]];
		pegaCuatroNumbers = [[NSMutableArray alloc] initWithArray:[decoder decodeObjectForKey:@"pegaCuatroNumbers"]];
		pegaTresNumbers = [[NSMutableArray alloc] initWithArray:[decoder decodeObjectForKey:@"pegaTresNumbers"]];
		pegaDosNumbers = [[NSMutableArray alloc] initWithArray:[decoder decodeObjectForKey:@"pegaDosNumbers"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:latestNumbers forKey:@"latestNumbers"];
	[encoder encodeObject:latestUpdate forKey:@"latestUpdate"];
	[encoder encodeObject:lotoNumbers forKey:@"lotoNumbers"];
	[encoder encodeObject:pegaCuatroNumbers forKey:@"pegaCuatroNumbers"];
	[encoder encodeObject:pegaTresNumbers forKey:@"pegaTresNumbers"];
	[encoder encodeObject:pegaDosNumbers forKey:@"pegaDosNumbers"];
}

- (void)addLotoObject:(LotterySix *)object {
	[lotoNumbers addObject:object];
}

- (void)addPegaCuatroObject:(LotteryFour *)object {
	[pegaCuatroNumbers  addObject:object];
}

- (void)addPegaTresObject:(LotteryThree *)object {
	[pegaTresNumbers  addObject:object];
}

- (void)addPegaDosObject:(LotteryTwo *)object {
	[pegaDosNumbers  addObject:object];
}

- (void)removeLotoObjectAtIndex:(NSInteger)index; {
	[lotoNumbers removeObjectAtIndex:index];
}

- (void)removePegaCuatroObjectAtIndex:(NSInteger)index {
	[pegaCuatroNumbers removeObjectAtIndex:index];
}

- (void)removePegaTresObjectAtIndex:(NSInteger)index {
	[pegaTresNumbers removeObjectAtIndex:index];
}

- (void)removePegaDosObjectAtIndex:(NSInteger)index {
	[pegaDosNumbers removeObjectAtIndex:index];
}

- (NSInteger)totalLotteryNumbers {
	NSInteger totalCount = [lotoNumbers count] + [pegaCuatroNumbers count] + [pegaTresNumbers count] + [pegaDosNumbers count];
	return totalCount;
}

- (void)updateLatestNumbersWithDictionary:(NSMutableDictionary *)dictionary {
	self.latestNumbers = dictionary;
	self.latestUpdate = [NSDate date];
}

- (BOOL)canAddNumbers {
	BOOL returnValue;
	NSInteger nextCount = [[LotteryData sharedLotteryData] totalLotteryNumbers] + 1;
	
	if ([[InAppPurchaseObserver sharedInAppPurchase] isPremium] == YES) {
		if (nextCount > MAX_PREMIUM_NUMBERS)
			returnValue = NO;
		else
			returnValue = YES;
	} else {
		if (nextCount > MAX_FREE_NUMBERS)
			returnValue = NO;
		else
			returnValue = YES;
	}
	return returnValue;
}

#pragma mark -
#pragma mark Singleton Methods

+ (LotteryData *)sharedLotteryData {
    if (!sharedLotteryData) {
        sharedLotteryData = [[LotteryData alloc] init];
	}
    return sharedLotteryData;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (!sharedLotteryData) {
        sharedLotteryData = [super allocWithZone:zone];
        return sharedLotteryData;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)release {
    // No op
}

- (void)dealloc {
	[latestNumbers release];
	[latestUpdate release];
	[lotoNumbers release];
	[pegaCuatroNumbers release];
	[pegaTresNumbers release];
	[pegaDosNumbers release];
	[super dealloc];
}

@end
