//
//  PrizeLoader.m
//  LotteryPR
//
//  Created by Axel Rivera on 11/14/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "PrizeLoader.h"
#import "Reachability.h"

static PrizeLoader *sharedPrizeLoader_;

@interface PrizeLoader (Private)

- (void)dispatchLoadingOperation;

@end

@implementation PrizeLoader

@synthesize delegate = delegate_;
@synthesize loaded = loaded_;

- (id)init
{
    self = [super init];
    if (self) {
        self.loaded = NO;
    }
    return self;
}

- (void)dealloc
{
    delegate_ = nil;
    [super dealloc];
}

#pragma mark - Custom Methods

- (void)load
{
    self.loaded = NO;
    [self dispatchLoadingOperation];
}

- (void)dispatchLoadingOperation
{
	NSOperationQueue *queue = [NSOperationQueue new];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(fetchPrizes)
																			  object:nil];
	[queue addOperation:operation];
	[operation release];
	[queue autorelease];
}

- (void)fetchPrizes
{
    BOOL networkAvailable = YES;
	Reachability *reach = [[Reachability reachabilityForInternetConnection] retain];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
		networkAvailable = NO;        
    }
	[reach release];
	if (!networkAvailable) {
        if ([delegate_ respondsToSelector:@selector(failedPrizesUpdateWithErrors:)]) {
            NSError *error = [NSError errorWithDomain:@"com.riveralabs.loteriapr" code:100 userInfo:nil];
            [delegate_ performSelectorOnMainThread:@selector(failedPrizesUpdateWithErrors:) withObject:error waitUntilDone:YES];
        }
	}
	
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:DefaultUrl];

    NSError *error = NULL;
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (error != NULL) {
        if ([delegate_ respondsToSelector:@selector(failedPrizesUpdateWithErrors:)]) {
            [delegate_ performSelectorOnMainThread:@selector(failedPrizesUpdateWithErrors:) withObject:error waitUntilDone:YES];
        }
    } else {
        NSString *pattern = @"\\loto=(\\d|,)+\\&revancha=(\\d|,)+";
        NSError *regexError = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&regexError];
        
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        
        NSString *matchStr = @"";
        
        if ([matches count] > 0) {
            NSString *tmpStr = [string substringWithRange:[[matches objectAtIndex:0] range]];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"loto=" withString:@""];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"revancha=" withString:@""];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"," withString:@""];
            matchStr = tmpStr;
        }
        
        NSString *lotoStr = @"0";
        NSString *revanchaStr = @"0";
        
        if ([matchStr length] > 0) {
            NSArray *array = [matchStr componentsSeparatedByString:@"&"];
            if ([array count] == 2) {
                lotoStr = [array objectAtIndex:0];
                revanchaStr = [array objectAtIndex:1];
            }
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:[lotoStr integerValue]], LotoKey,
                                    [NSNumber numberWithInteger:[revanchaStr integerValue]], RevanchaKey,
                                    nil];
        
        if ([delegate_ respondsToSelector:@selector(updatedPrizes:)]) {
            [delegate_ performSelectorOnMainThread:@selector(updatedPrizes:) withObject:dictionary waitUntilDone:YES];
        }
    }
}

#pragma mark - Private Methods

#pragma mark - Singleton Methods

+ (PrizeLoader *)sharedPrizeLoader
{
	if (sharedPrizeLoader_ == nil) {
		sharedPrizeLoader_ = [[super allocWithZone:NULL] init];
	}
	return sharedPrizeLoader_;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedPrizeLoader] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
	//do nothing
}

- (id)autorelease
{
	return self;
}

@end
