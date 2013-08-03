//
//  LotteryViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryViewController.h"
#import "LinkViewController.h"
#import "NumbersViewController.h"
#import "AboutViewController.h"
#import "LotteryData.h"
#import "Lottery.h"
#import "LotteryTwo.h"
#import "LotteryThree.h"
#import "LotteryFour.h"
#import "LotterySix.h"
#import "FileHelpers.h"
#import "LotteryBallView.h"
#import "LotteryCell.h"
#import "Reachability.h"

@implementation LotteryViewController

@synthesize lotteryTable = lotteryTable_;
@synthesize lotteryNumbers;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.navigationBar.topItem.title = @"Números Ganadores";
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Ganadores";
	self.navigationItem.backBarButtonItem = barButtonItem;
	[barButtonItem release];
    
	[self showInfoButtonItem];
	[self showRefreshButtonItem];
	[self setLotteryNumbers:[NSDictionary dictionaryWithDictionary:[[LotteryData sharedLotteryData] latestNumbers]]];
    numberLoader_ = [NumberLoader sharedNumberLoader];
    numberLoader_.delegate = self;
    [self.lotteryTable reloadData];
    [self loadNumbers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    lotteryTable_ = nil;
	lotteryNumbers = nil;
	[super viewDidUnload];
}

- (void)dealloc {
    numberLoader_.delegate = nil;
    [lotteryTable_ release];
	[lotteryNumbers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (void)loadNumbers
{
    [numberLoader_ load];
}

- (void)loadAbout {
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
																					 bundle:nil];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
#pragma mark Class Methods

- (void)showLoadingButtonItem {
	// initing the loading view
	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:frame];
	[loading startAnimating];
	[loading sizeToFit];
	loading.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
								UIViewAutoresizingFlexibleRightMargin |
								UIViewAutoresizingFlexibleTopMargin |
								UIViewAutoresizingFlexibleBottomMargin);
	
	// initing the bar button
	UIBarButtonItem *loadingView = [[[UIBarButtonItem alloc] initWithCustomView:loading] autorelease];
	
	[loading release];
	loadingView.target = self;
	self.navigationItem.rightBarButtonItem = loadingView;	
}

- (void)showRefreshButtonItem {
	UIBarButtonItem *reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																					  target:self
																					  action:@selector(loadNumbers)];
	
	self.navigationItem.rightBarButtonItem = reloadButtonItem;
	[reloadButtonItem release];
}

- (void)showInfoButtonItem {
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"]
																		style:UIBarButtonItemStyleBordered
																	   target:self
																	   action:@selector(loadAbout)];
	
	self.navigationItem.leftBarButtonItem = infoButtonItem;
	[infoButtonItem release];
}

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (lotteryNumbers == nil) {
		return 0;
	}
    return [lotteryNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LotteryCell *cell = (LotteryCell *)[tableView dequeueReusableCellWithIdentifier:@"LotteryCell"];
	if (cell == nil) {
		cell = [[[LotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LotteryCell"] autorelease];
	}
	
	if (indexPath.row == 0) {
		LotterySix *loto = [lotteryNumbers objectForKey:LotoKey];
		[cell setLoto:loto];
	} else if (indexPath.row == 1) {
		LotterySix *revancha = [lotteryNumbers objectForKey:RevanchaKey];
		[cell setRevancha:revancha];
	} else if (indexPath.row == 2) {
		LotteryFour *pegaCuatro = [lotteryNumbers objectForKey:PegaCuatroKey];
		[cell setPegaCuatro:pegaCuatro];
	} else if (indexPath.row == 3) {
		LotteryThree *pegaTres = [lotteryNumbers objectForKey:PegaTresKey];
		[cell setPegaTres:pegaTres];
	} else if (indexPath.row == 4) {
		LotteryTwo *pegaDos = [lotteryNumbers objectForKey:PegaDosKey];
		[cell setPegaDos:pegaDos];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
//	if (linkViewController == nil) {
//		linkViewController = [[LinkViewController alloc] init];
//	}
//	
//	if (indexPath.row == 0) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:LotoKey]];
//	} else if (indexPath.row == 1) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:RevanchaKey]];
//	} else if (indexPath.row == 2) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaCuatroKey]];
//	} else if (indexPath.row == 3) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaTresKey]];
//	} else if (indexPath.row == 4) {
//		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaDosKey]];
//	}
//
//	linkViewController.hidesBottomBarWhenPushed = YES;
//	[[self navigationController] pushViewController:linkViewController 
//										   animated:YES];
}

#pragma mark - Number Loader Delegate

- (void)updatedNumbers:(NSDictionary *)numbers
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:numbers];
    [[LotteryData sharedLotteryData] updateLatestNumbersWithDictionary:dictionary];
    [dictionary release];
    self.lotteryNumbers = numbers;
    [self.lotteryTable reloadData];
}

- (void)failedNumbersUpdateWithErrors:(NSError *)error
{
    if (error) {
        NSString *errorStr = @"Parece que la pagina web de la Lotería Electrónica esta teniendo problemas o la conexion de Internet no está disponible.";
        [self performSelector:@selector(loadError:) withObject:errorStr];
        [self.lotteryTable reloadData];
    }
}

- (void)willBeginUpdatingNumbers
{
    [self showLoadingButtonItem]; 
}

- (void)didFinishUpdatingNumbers
{
    [self showRefreshButtonItem];
}

- (void)loadError:(NSString *)errorStr
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorStr
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
