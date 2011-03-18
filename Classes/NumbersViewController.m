//
//  NumbersViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "NumbersViewController.h"
#import "AddNumberViewController.h"
#import "EditNumberViewController.h"
#import "NumbersSelectViewController.h"
#import "AboutViewController.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryData.h"
#import "InAppPurchaseObserver.h"

@implementation NumbersViewController

@synthesize lotteryControl;
@synthesize numbersTable;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Mis Números";
	
	self.editButtonItem.title = @"Editar";
	
	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	[self showAddButton];
	
	[lotteryControl setTitle:LotoTitle forSegmentAtIndex:0];
	[lotteryControl setTitle:PegaCuatroTitle forSegmentAtIndex:1];
	[lotteryControl setTitle:PegaTresTitle forSegmentAtIndex:2];
	[lotteryControl setTitle:PegaDosTitle forSegmentAtIndex:3];
	
	lotteryData = [LotteryData sharedLotteryData];
	// Default Segment is Loto
	[lotteryControl setSelectedSegmentIndex:0];
	currentNumbers = lotteryData.lotoNumbers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.numbersTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self setEditing:NO animated:NO];
}

#pragma mark Memory Management

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.lotteryControl = nil;
	self.numbersTable = nil;
}

- (void)dealloc {
    [super dealloc];
	[lotteryControl release];
	[numbersTable release];
}

#pragma mark -
#pragma mark Custom Action Methods

- (IBAction)addNumber:(id)sender {
	if (![lotteryData canAddNumbers]) {
		if ([[InAppPurchaseObserver sharedInAppPurchase] isPremium]) {
			[self showPremiumAlert];
		} else {
			[self showFreeAlert];
		}
		return;
	}
	
	AddNumberViewController *controller = [[AddNumberViewController alloc] initWithNibName:@"AddNumberViewController"
																					 bundle:nil];
	NSString *currentGame = nil;
	if ([lotteryControl selectedSegmentIndex] == 0) {
		currentGame = LotoTitle;
	} else if ([lotteryControl selectedSegmentIndex] == 1) {
		currentGame = PegaCuatroTitle;
	} else if ([lotteryControl selectedSegmentIndex] == 2) {
		currentGame = PegaTresTitle;
	} else {
		currentGame = PegaDosTitle;
	}

	[controller setCurrentGame:currentGame];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (IBAction)controlAction:(id)sender {
	if ([lotteryControl selectedSegmentIndex] == 0) {
		currentNumbers = lotteryData.lotoNumbers;
	} else if ([lotteryControl selectedSegmentIndex] == 1) {
		currentNumbers = lotteryData.pegaCuatroNumbers;
	} else if ([lotteryControl selectedSegmentIndex] == 2) {
		currentNumbers = lotteryData.pegaTresNumbers;
	} else {
		currentNumbers = lotteryData.pegaDosNumbers;
	}
	
	[self.numbersTable reloadData];
	
	[self.numbersTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark -
#pragma mark Custom Methods

- (void)showAddButton {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(addNumber:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)showRemoveButton {
	UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:@"Borrar Todos"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(removeAllFromCurrent)];
    self.navigationItem.rightBarButtonItem = removeButton;
    [removeButton release];
}

- (void)removeAllFromCurrent {
	[currentNumbers removeAllObjects];
	[self.numbersTable reloadData];
	[self setEditing:NO animated:YES];
}

- (void)showFreeAlert {
	NSString *messageString = [NSString stringWithFormat:@"La versión Gratis de Loteria Puerto Rico te permite"
							   " guardar un máximo de %d números. ¿Deseas comprar la versión Premium?", MAX_FREE_NUMBERS];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loteria Puerto Rico"
													message:messageString
												   delegate:self
										cancelButtonTitle:@"Cancelar"
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)showPremiumAlert {
	NSString *messageString = [NSString stringWithFormat:@"La versión Premium de Loteria Puerto Rico te permite"
							   " guardar un máximo de %d números.", MAX_PREMIUM_NUMBERS];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loteria Puerto Rico"
													message:messageString
												   delegate:self
										  cancelButtonTitle:@"Cancelar"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark  UITable View Methods

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"LotteryCell";
    UITableViewCell *cell = [self.numbersTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
    }
	
	Lottery *currentLottery = [currentNumbers objectAtIndex:indexPath.row];
	
	NSString *playString = nil;
	if ([lotteryControl selectedSegmentIndex] == 0) {
		playString = [(LotterySix *)currentLottery bonusPlayString];
	} else {
		playString = [currentLottery lotteryTypeToString];
	}
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
								 playString];
	
    cell.textLabel.text = [currentLottery numbersToString];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [currentNumbers count];
}

#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (editNumberViewController == nil) {
		editNumberViewController = [[EditNumberViewController alloc] initWithNibName:@"EditNumberViewController"
																			  bundle:nil];
	}
	
	Lottery *currentLottery = [currentNumbers objectAtIndex:indexPath.row];
	
	[editNumberViewController setCurrentLottery:currentLottery];
	[editNumberViewController setCurrentGame:[currentLottery gameName]];
	[editNumberViewController setStart:YES];
	
	editNumberViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:editNumberViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (numbersSelectViewController == nil) {
		numbersSelectViewController = [[NumbersSelectViewController alloc] initWithNibName:@"NumbersSelectViewController"
																					bundle:nil];
	}
	
	[numbersSelectViewController setCurrentLottery:[currentNumbers objectAtIndex:indexPath.row]];
	
	numbersSelectViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:numbersSelectViewController animated:YES];	
}

#pragma mark UITableView Editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([lotteryControl selectedSegmentIndex] == 0) {
			[lotteryData removeLotoObjectAtIndex:indexPath.row];
		} else if ([lotteryControl selectedSegmentIndex] == 1) {
			[lotteryData removePegaCuatroObjectAtIndex:indexPath.row];
		} else if ([lotteryControl selectedSegmentIndex] == 2) {
			[lotteryData removePegaTresObjectAtIndex:indexPath.row];
		} else {
			[lotteryData removePegaDosObjectAtIndex:indexPath.row];
		}
		[self.numbersTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						 withRowAnimation:YES];
    }   
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	// Always call super implementation of this method, it needs to do some work
	[super setEditing:editing animated:animated];
	[self.numbersTable setEditing:editing animated:animated];
	
	if (!editing) {
		self.editButtonItem.title = @"Editar";
		[self showAddButton];
		lotteryControl.enabled = YES;
	} else {
		self.editButtonItem.title = @"Terminar";
		[self showRemoveButton];
		lotteryControl.enabled = NO;
	}
}

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([@"OK" isEqualToString:[alertView buttonTitleAtIndex:buttonIndex]]) {
		AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
																				bundle:nil];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

@end
