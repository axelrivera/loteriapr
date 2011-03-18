//
//  AboutViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	UIButton *inappButton;
	UIScrollView *scrollView;
	UILabel *versionLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *inappButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

- (IBAction)done:(id)sender;
- (IBAction)buyInApp:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)goToWebsite:(id)sender;

- (void)displayComposerSheet;

@end
