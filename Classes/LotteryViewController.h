//
//  LotteryViewController.h
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface LotteryViewController : UITableViewController <NSXMLParserDelegate> {	
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

- (void)loadNumbers;

- (UILabel *)numberLabel:(NSNumber *)num withPoint:(CGPoint)pt;

- (void)addNumberLabelsToView:(UIView *)numView withNumbers:(NSArray *)numArray;

@end
