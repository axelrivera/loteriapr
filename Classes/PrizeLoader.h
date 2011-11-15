//
//  PrizeLoader.h
//  LotteryPR
//
//  Created by Axel Rivera on 11/14/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

@protocol PrizeLoaderDelegate

@optional

- (void)updatedPrizes:(NSDictionary *)prizes;
- (void)failedPrizesUpdateWithErrors:(NSError *)error;

@end

@interface PrizeLoader : NSObject <NSXMLParserDelegate>

@property (nonatomic, assign) UIViewController <PrizeLoaderDelegate> *delegate;
@property (nonatomic, assign) BOOL loaded;

+ (PrizeLoader *)sharedPrizeLoader;

- (void)load;

@end
