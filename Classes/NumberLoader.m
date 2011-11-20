//
//  NumberLoader.m
//  LotteryPR
//
//  Created by Axel Rivera on 11/14/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "NumberLoader.h"
#import "Reachability.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"

static NumberLoader *sharedNumberLoader_;
static BOOL validRSS_;

@interface NumberLoader (Private)

- (NSMutableDictionary *)numbers;
- (void)setNumbers:(NSMutableDictionary *)numbers;

- (NSError *)numberFetchError;
- (void)setNumberFetchError:(NSError *)error;

- (void)dispatchLoadingOperation;

@end

@implementation NumberLoader

@synthesize delegate = delegate_;
@synthesize loaded = loaded_;

- (id)init
{
    self = [super init];
    if (self) {
        [self setNumbers:[NSMutableDictionary dictionaryWithCapacity:0]];
        self.loaded = NO;
    }
    return self;
}

- (void)dealloc
{
    delegate_ = nil;
    [numbers_ release];
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
																			selector:@selector(fetchNumbers)
																			  object:nil];
	
	[queue addOperation:operation];
	[operation release];
	[queue autorelease];
}

- (void)fetchNumbers
{
	if ([delegate_ respondsToSelector:@selector(willBeginUpdatingNumbers)]) {
		[delegate_ performSelectorOnMainThread:@selector(willBeginUpdatingNumbers)
										withObject:nil
									 waitUntilDone:YES];
	}
	
	[self performSelectorOnMainThread:@selector(fetchNumbersDictionary) withObject:nil waitUntilDone:YES];
}

- (void)fetchNumbersDictionary
{
	[numbers_ removeAllObjects];
	[self setNumberFetchError:nil];
	
	isNumberFetchPending_ = YES;
	
    validRSS_ = NO;
    
    BOOL networkAvailable = YES;
	Reachability *reach = [[Reachability reachabilityForInternetConnection] retain];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
		networkAvailable = NO;        
    }
	[reach release];
	if (!networkAvailable) {
        // Call Error Delegate method
	}
	
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:DefaultRss];
	
	// Create a request object with that URL								  
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringCacheData 
										 timeoutInterval:30]; 
	
    [self cancelData];
	
	// Create and initiate the connection
    connectionInProgress_ = [[NSURLConnection alloc] initWithRequest:request 
                                                           delegate:self 
                                                   startImmediately:YES]; 
	
	// Instantiate the object to hold all incoming data
    [xmlData_ autorelease]; 
    xmlData_ = [[NSMutableData alloc] init]; 
}

- (void)cancelData
{
    if (connectionInProgress_) {
        [connectionInProgress_ cancel];
        [connectionInProgress_ release];
        connectionInProgress_ = nil;
    }
}

#pragma mark - Private Methods

- (NSMutableDictionary *)numbers
{
    return numbers_;
}

- (void)setNumbers:(NSMutableDictionary *)numbers
{
    [numbers_ autorelease];
    numbers_ = [numbers retain];
}

- (NSError *)numberFetchError
{
    return numberFetchError_;
}

- (void)setNumberFetchError:(NSError *)error
{
    [numberFetchError_ autorelease];
    numberFetchError_ = [error retain];
}

#pragma mark NSXMLParser Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { 
    [xmlData_ appendData:data]; 
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData_]; 
	[parser setDelegate:self];
	[parser parse];
	
	[parser release];
    
    if ([delegate_ respondsToSelector:@selector(updatedNumbers:)]) {
        [delegate_ performSelectorOnMainThread:@selector(updatedNumbers:) withObject:numbers_ waitUntilDone:YES];
    }
    
    if ([delegate_ respondsToSelector:@selector(didFinishUpdatingNumbers)]) {
        [delegate_ performSelectorOnMainThread:@selector(didFinishUpdatingNumbers) withObject:nil waitUntilDone:YES];
    }
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"rss"]) {
		validRSS_ = YES;
	}
	
	if (!validRSS_) {
		[parser abortParsing];
	}
	
	if([elementName isEqual:xmlItem]) {
		waitingForItemTitle_ = YES;
		waitingForItemDate_ = YES;
	}
	if (tmpString_ != nil) {
		[tmpString_ release];
		tmpString_ = nil;
	}
	tmpString_ = [[NSMutableString alloc] initWithCapacity:1];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    [tmpString_ appendString:string];
} 

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqual:xmlTitleItem] && waitingForItemTitle_) { 
		titleString_ = [NSMutableString stringWithString:tmpString_];
    }
    if ([elementName isEqual:xmlDateItem] && waitingForItemDate_) { 
		dateString_ = [NSMutableString stringWithString:tmpString_];
    }
	
	[tmpString_ release];
	tmpString_ = nil;
	
	if([elementName isEqual:xmlItem]) {
		NSArray *titleAndNumber = [titleString_ componentsSeparatedByString:xmlTitleDivider];
		
		if ([LotoTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *loto = [[LotterySix alloc] initWithName:LotoTitle
														numbers:[titleAndNumber objectAtIndex:1]
														   date:dateString_];
			[numbers_ setObject:loto forKey:LotoKey];
			[loto release];
			loto = nil;
		}
		
		if ([RevanchaTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *revancha = [[LotterySix alloc] initWithName:RevanchaTitle
															numbers:[titleAndNumber objectAtIndex:1]
															   date:dateString_];
			[numbers_ setObject:revancha forKey:RevanchaKey];
			[revancha release];
			revancha = nil;
		}
		
		if ([PegaCuatroTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:PegaCuatroTitle
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString_];
			[numbers_ setObject:pegaCuatro forKey:PegaCuatroKey];
			[pegaCuatro release];
			pegaCuatro = nil;
		}
		
		if ([PegaTresTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:PegaTresTitle
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString_];
			[numbers_ setObject:pegaTres forKey:PegaTresKey];
			[pegaTres release];
			pegaTres = nil;
		}
		
		if ([PegaDosTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:PegaDosTitle
                                                           numbers:[titleAndNumber objectAtIndex:1]
                                                              date:dateString_];
			[numbers_ setObject:pegaDos forKey:PegaDosKey];
			[pegaDos release];
			pegaDos = nil;
		}
		
		waitingForItemTitle_ = NO;
		waitingForItemDate_ = NO;
	}	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { 
    [connectionInProgress_ release]; 
    connectionInProgress_ = nil; 
    [xmlData_ release]; 
    xmlData_ = nil; 
//    NSString *errorString = [NSString stringWithFormat:@"No Internet Connection Available", 
//                             [error localizedDescription]]; 
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
//													message:errorString
//												   delegate:self
//										  cancelButtonTitle:@"OK"
//										  otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
    if ([delegate_ respondsToSelector:@selector(failedNumbersUpdateWithErrors:)]) {
        [delegate_ performSelectorOnMainThread:@selector(failedNumbersUpdateWithErrors:) withObject:error waitUntilDone:YES];
    }
    
    if ([delegate_ respondsToSelector:@selector(didFinishUpdatingNumbers)]) {
        [delegate_ performSelectorOnMainThread:@selector(didFinishUpdatingNumbers) withObject:nil waitUntilDone:YES];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
//	NSString *errorString = [NSString stringWithFormat:@"La información no esta disponible en la página web de la Loteria Electrónica"]; 
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//													message:errorString
//												   delegate:self
//										  cancelButtonTitle:@"OK"
//										  otherButtonTitles: nil];
//	[alert show];	
//	[alert release];
    if ([delegate_ respondsToSelector:@selector(failedNumbersUpdateWithErrors:)]) {
        [delegate_ performSelectorOnMainThread:@selector(failedNumbersUpdateWithErrors:) withObject:parseError waitUntilDone:YES];
    }
    
    if ([delegate_ respondsToSelector:@selector(didFinishUpdatingNumbers)]) {
        [delegate_ performSelectorOnMainThread:@selector(didFinishUpdatingNumbers) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - Singleton Methods

+ (NumberLoader *)sharedNumberLoader
{
	if (sharedNumberLoader_ == nil) {
		sharedNumberLoader_ = [[super allocWithZone:NULL] init];
	}
	return sharedNumberLoader_;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedNumberLoader] retain];
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
