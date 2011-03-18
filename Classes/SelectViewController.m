//
//  SelectViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "SelectViewController.h"
#import "AddNumberViewController.h"

NSInteger initialIndex;

@implementation SelectViewController

@synthesize selectTable;
@synthesize selectArray;
@synthesize currentSelect;
@synthesize selectType;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if ([selectType isEqualToString:LotoTitle]) {
		selectArray = [[NSArray alloc] initWithObjects:LotoTitle, PegaCuatroTitle, PegaTresTitle, PegaDosTitle, nil];
		if (currentSelect == LotoTitle) {
			initialIndex = 0;
		} else if ([currentSelect isEqualToString:PegaCuatroTitle]) {
			initialIndex = 1;
		} else if ([currentSelect isEqualToString:PegaTresTitle]) {
			initialIndex = 2;
		} else if ([currentSelect isEqualToString:PegaDosTitle]) {
			initialIndex = 3;
		} else {
			initialIndex = 0;
			currentSelect = [selectArray objectAtIndex:initialIndex];
		}

	} else {
		selectArray = [[NSArray alloc] initWithObjects:@"Exacta", @"Combinada", @"Exacta/Combinada", nil];
		if ([currentSelect isEqualToString:@"Exacta"]) {
			initialIndex = 0;
		} else if ([currentSelect isEqualToString:@"Combinada"]) {
			initialIndex = 1;
		} else if ([currentSelect isEqualToString:@"Exacta/Combinada"]) {
			initialIndex = 2;
		} else {
			initialIndex = 0;
			currentSelect = [selectArray objectAtIndex:initialIndex];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([currentSelect isEqualToString:LotoTitle]) {
		self.title = @"Juego";
	} else {
		self.title = @"Jugada";
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	AddNumberViewController *addNumberViewController = (AddNumberViewController *)self.navigationController.topViewController;
	if ([selectType isEqualToString:LotoTitle]) {
		[addNumberViewController setCurrentGame:currentSelect];
	} else {
		[addNumberViewController setPlayType:currentSelect];
	}	
}

#pragma mark Memory Management

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	selectTable = nil;
}

- (void)dealloc {
    [super dealloc];
	[selectTable release];
	[selectArray release];
	[currentSelect release];
	[selectType release];
}

#pragma mark -
#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameCell"] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (indexPath.row == initialIndex) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
	
	cell.textLabel.text = [selectArray objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [selectArray count];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [selectTable deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger gameIndex = [selectArray indexOfObject:currentSelect];
    if (gameIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:gameIndex inSection:0];
	
    UITableViewCell *newCell = [selectTable cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        currentSelect = [selectArray objectAtIndex:indexPath.row];
    }
	
    UITableViewCell *oldCell = [selectTable cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
