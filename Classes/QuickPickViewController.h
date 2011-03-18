//
//  QuickPickViewController.h
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@class PickerViewController;

@interface QuickPickViewController : UITableViewController {
	NSArray *dataSource;
	PickerViewController *pickerViewController;
	
	UITableViewCell *nibLoadedCell;
}

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

@end
