//
//  LotteryPRAppDelegate.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryPRAppDelegate.h"
#import "NumbersViewController.h"
#import "VerifyViewController.h"
#import "LotteryData.h"
#import "InAppPurchaseObserver.h"

@implementation LotteryPRAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppPurchaseObserver sharedInAppPurchase]];
	
	NSString *lotteryPath = [self lotteryFilePath];
	
	LotteryData *lotteryData = [NSKeyedUnarchiver unarchiveObjectWithFile:lotteryPath];
	
	if (lotteryData == nil)
		[LotteryData sharedLotteryData];
	
    // Override point for customization after application launch.
		
	[[tabBarController.viewControllers objectAtIndex:0] setTitle:@"Ganadores"];
	[[tabBarController.viewControllers objectAtIndex:1] setTitle:@"Verificar"];
	[[tabBarController.viewControllers objectAtIndex:2] setTitle:@"Mis Números"];
	[[tabBarController.viewControllers objectAtIndex:3] setTitle:@"Automática"];
	
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[InAppPurchaseObserver sharedInAppPurchase] requestProducts];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSString *lotteryPath = [self lotteryFilePath];	
	[NSKeyedArchiver archiveRootObject:[LotteryData sharedLotteryData] toFile:lotteryPath];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSString *lotteryPath = [self lotteryFilePath];	
	[NSKeyedArchiver archiveRootObject:[LotteryData sharedLotteryData] toFile:lotteryPath];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {	
    [window release];
	[tabBarController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods

- (NSString *)lotteryFilePath {
	return pathInDocumentDirectory(@"LotteryFile.data");
}

- (void)archiveLottery {
	NSString *lotteryPath = [self lotteryFilePath];
	[NSKeyedArchiver archiveRootObject:[LotteryData sharedLotteryData] toFile:lotteryPath];
}


@end
