//
//  LotteryViewController.h
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class LinkViewController;

@interface LotteryViewController : UITableViewController <NSXMLParserDelegate> {
	LinkViewController *linkViewController;
	
	BOOL waitingForItemTitle;
	BOOL waitingForItemDate;
	
	NSMutableDictionary *lotteryNumbers;
    NSMutableData *xmlData; 
	NSURLConnection *connectionInProgress;
	
	NSMutableString *tmpString;
	NSMutableString *titleString;
	NSMutableString *dateString;
	
	UITableViewCell *nibLoadedCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic, retain) NSMutableDictionary *lotteryNumbers;

- (IBAction)loadNumbers:(id)sender;

- (UILabel *)numberLabel:(NSNumber *)num withPoint:(CGPoint)pt;

- (void)addNumberLabelsToView:(UIView *)numView withNumbers:(NSArray *)numArray;

- (void)showLoadingButtonItem;

- (void)showRefreshButtonItem;

- (NSString *)lotteryFilePath;

@end
