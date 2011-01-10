//
//  LotteryPRAppDelegate.h
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@class LotteryViewController;

@interface LotteryPRAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

