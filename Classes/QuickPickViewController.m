//
//  QuickPickViewController.m
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickPickViewController.h"
#import "PickerViewController.h"


@implementation QuickPickViewController

@synthesize dataSource;
@synthesize nibLoadedCell;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.navigationBar.topItem.title = @"Lotería Automática";
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Automática";
	self.navigationItem.backBarButtonItem = barButtonItem;
	[barButtonItem release];
	
	dataSource = [[NSArray alloc] initWithObjects: LotoTitle, PegaCuatroTitle, PegaTresTitle, PegaDosTitle, nil];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"QuickPickTableCell" owner:self options:NULL];
		cell = nibLoadedCell;
	}
		
	UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
	UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
	
	if (indexPath.row == 0) {
		[imageView setImage:[UIImage imageNamed:@"loto_sphere.png"]];
	} else if (indexPath.row == 1) {
		[imageView setImage:[UIImage imageNamed:@"pegacuatro_sphere.png"]];
	} else if (indexPath.row == 2) {
		[imageView setImage:[UIImage imageNamed:@"pegatres_sphere.png"]];
	} else {
		[imageView setImage:[UIImage imageNamed:@"pegados_sphere.png"]];
	}

	textLabel.text = [dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (linkViewController == nil) {
//		linkViewController = [[LinkViewController alloc] init];
//	}
//	
//	if (indexPath.row == 0) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:@"lotoKey"]];
//	} else if (indexPath.row == 1) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:@"revanchaKey"]];
//	} else if (indexPath.row == 2) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:@"pegaCuatroKey"]];
//	} else if (indexPath.row == 3) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:@"pegaTresKey"]];
//	} else if (indexPath.row == 4) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:@"pegaDosKey"]];
//	}
//	
//	linkViewController.hidesBottomBarWhenPushed = YES;
//	[[self navigationController] pushViewController:linkViewController 
//										   animated:YES];
	
	NSString *lotteryName = @"";
	if (indexPath.row == 0) {
		lotteryName = LotoTitle;
	} else if (indexPath.row == 1) {
		lotteryName = PegaCuatroTitle;
	} else if (indexPath.row == 2) {
		lotteryName = PegaTresTitle;
	} else {
		lotteryName = PegaDosTitle;
	}

	if (pickerViewController == nil)
		pickerViewController = [[PickerViewController alloc] init];
	
	pickerViewController.lotteryName = lotteryName;
	pickerViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:pickerViewController animated:YES];
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	nibLoadedCell = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dataSource release];
	[nibLoadedCell release];
    [super dealloc];
}


@end
