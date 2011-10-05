//
//  QuickPickViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
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

#pragma mark -
#pragma mark UITableView Data Source

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
	return 85.0;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *lotteryName = @"";
    PickerViewType pickerType;
	if (indexPath.row == 0) {
		lotteryName = LotoTitle;
        pickerType = PickerViewTypeSix;
	} else if (indexPath.row == 1) {
		lotteryName = PegaCuatroTitle;
        pickerType = PickerViewTypeFour;
	} else if (indexPath.row == 2) {
		lotteryName = PegaTresTitle;
        pickerType = PickerViewTypeThree;
	} else {
		lotteryName = PegaDosTitle;
        pickerType = PickerViewTypeTwo;
	}


    PickerViewController *pickerViewController = [[PickerViewController alloc] initWithPickerType:pickerType];
	pickerViewController.lotteryName = lotteryName;
	pickerViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:pickerViewController animated:YES];
    [pickerViewController release];
}

@end
