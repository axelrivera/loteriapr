//
//  LinkViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface LinkViewController : UIViewController <UIActionSheetDelegate> {
	UIWebView *webView;
	UIBarButtonItem *actionButton;
	UIBarButtonItem *refreshButton;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
