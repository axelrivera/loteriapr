//
//  InAppPurchaseObserver.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kPremiumIdentifier					@"com.riveralabs.loteriapr.premium"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface InAppPurchaseObserver : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	BOOL premiumAvailable;
	NSString *premiumIdentifier;
	BOOL isPremium;
	SKProductsRequest *request;
}

@property (nonatomic) BOOL premiumAvailable;
@property (nonatomic, copy, readonly) NSString *premiumIdentifier;
@property (nonatomic) BOOL isPremium;
@property (nonatomic, retain) SKProductsRequest *request;

+ (InAppPurchaseObserver *)sharedInAppPurchase;

- (void)requestProducts;
- (void)buyPremium;

@end
