//
//  NumberLoader.h
//  LotteryPR
//
//  Created by Axel Rivera on 11/14/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol NumberLoaderDelegate

@optional

- (void)updatedNumbers:(NSDictionary *)numbers;
- (void)failedNumbersUpdateWithErrors:(NSError *)error;
- (void)willBeginUpdatingNumbers;
- (void)didFinishUpdatingNumbers;

@end

@interface NumberLoader : NSObject <NSXMLParserDelegate>
{
    NSMutableDictionary *numbers_;
    NSMutableData *xmlData_;
    NSURLConnection *connectionInProgress_;
    
    NSMutableString *tmpString_;
	NSMutableString *titleString_;
	NSMutableString *dateString_;
    
	BOOL isNumberFetchPending_;
    BOOL waitingForItemTitle_;
    BOOL waitingForItemDate_;
    
    NSError *numberFetchError_;
}

@property (nonatomic, assign) UIViewController <NumberLoaderDelegate> *delegate;
@property (nonatomic, assign) BOOL loaded;

+ (NumberLoader *)sharedNumberLoader;

- (void)load;
- (void)cancelData;

@end
