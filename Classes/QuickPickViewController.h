//
//  QuickPickViewController.h
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerViewController;

@interface QuickPickViewController : UITableViewController {
	NSArray *dataSource;
	PickerViewController *pickerViewController;
	
	UITableViewCell *nibLoadedCell;
}

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

@end
