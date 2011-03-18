//
//  SelectViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@interface SelectViewController : UIViewController {
	UITableView *selectTable;
	NSArray *selectArray;
	NSString *currentSelect;
	NSString *selectType;
}

@property (nonatomic, retain) IBOutlet UITableView *selectTable;
@property (nonatomic, copy) NSArray *selectArray;
@property (nonatomic, copy) NSString *currentSelect;
@property (nonatomic, copy) NSString *selectType;

@end
