//
//  LotteryPRAppDelegate.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@interface LotteryPRAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (NSString *)lotteryFilePath;
- (void)archiveLottery;

@end

