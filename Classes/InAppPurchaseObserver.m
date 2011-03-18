//
//  InAppPurchaseObserver.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "InAppPurchaseObserver.h"
#import "Reachability.h"

@interface InAppPurchaseObserver (Private)

- (void)completeTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)recordTransaction:(SKPaymentTransaction *)transaction;
- (void)provideContent:(NSString *)identifier;

@end

@implementation InAppPurchaseObserver

static InAppPurchaseObserver *sharedInAppPurchase;

@synthesize premiumIdentifier;
@synthesize premiumAvailable;
@synthesize isPremium;
@synthesize request;

- (id)init {
	if ((self = [super init])) {
		premiumIdentifier = [[NSString alloc] initWithString:kPremiumIdentifier];
		BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:self.premiumIdentifier];
		
		self.premiumAvailable = NO;
		self.isPremium = NO;
		
		if (productPurchased) {
			self.isPremium = YES;
			self.premiumAvailable = YES;
		}
	}
	return self;
}

- (void)requestProducts {
	Reachability *reach = [[[Reachability reachabilityForInternetConnection] retain] autorelease];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];
	if (netStatus == NotReachable && self.isPremium == NO) {        
		self.premiumAvailable = NO;
		return;
	}
	
	if ([SKPaymentQueue canMakePayments] == NO && self.isPremium == NO) {
		self.premiumAvailable = NO;
		return;
	}
	
	request = [[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.premiumIdentifier]] autorelease];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	SKProduct *validProduct = nil;
	int count = [response.products count];
	if (count > 0) {
		validProduct = [response.products objectAtIndex:0];
	}
	
	if ([validProduct.productIdentifier isEqualToString:self.premiumIdentifier]) {
		self.premiumAvailable = YES;
	}
}

- (void)buyPremium {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:self.premiumIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -
#pragma mark Store Kit Payment Transaction Observer

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	// Your application should implement these two methods.
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
	[[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
	
}

- (void)provideContent:(NSString *)identifier {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.premiumIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.isPremium = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:self.premiumIdentifier];
}

#pragma mark -
#pragma mark Singleton Methods

+ (InAppPurchaseObserver *)sharedInAppPurchase {
    if (!sharedInAppPurchase) {
        sharedInAppPurchase = [[InAppPurchaseObserver alloc] init];
	}
    return sharedInAppPurchase;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (!sharedInAppPurchase) {
        sharedInAppPurchase = [super allocWithZone:zone];
        return sharedInAppPurchase;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
