//
//  VerifyViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "VerifyViewController.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryData.h"
#import "VerifyCell.h"
#import "LotteryBallView.h"
#import "LotteryBall.h"
#import "LotteryNumbersCell.h"

@implementation VerifyViewController

@synthesize segmentedControl;
@synthesize numbersTable;
@synthesize lotoArray, revanchaArray, pegaCuatroArray, pegaTresArray, pegaDosArray;

- (void)viewDidLoad {
	[super viewDidLoad];
	//self.navigationItem.title = @"Verificar Mis Números";
	
	NSArray *segmentedControlItems = [NSArray arrayWithObjects:LotoTitle, RevanchaTitle, @"Otros", nil];
	
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	NSInteger itemCount = [segmentedControlItems count];
	CGFloat segmentedWidth = round(([UIScreen mainScreen].bounds.size.width - 20.0) / itemCount);
	
	for (NSInteger i = 0; i < itemCount; i++) {
		[segmentedControl setWidth:segmentedWidth forSegmentAtIndex:i];
	}
	
	[segmentedControl addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = segmentedControl;
	
	lotoArray = [[NSMutableArray alloc] initWithCapacity:0];
	revanchaArray = [[NSMutableArray alloc] initWithCapacity:0];
	pegaCuatroArray = [[NSMutableArray alloc] initWithCapacity:0];
	pegaTresArray = [[NSMutableArray alloc] initWithCapacity:0];
	pegaDosArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	lotteryData = [LotteryData sharedLotteryData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self verifyNumbers];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.segmentedControl = nil;
	self.numbersTable = nil;
	self.lotoArray = nil;
	self.revanchaArray = nil;
	self.pegaCuatroArray = nil;
	self.pegaTresArray = nil;
	self.pegaDosArray = nil;
}

- (void)dealloc {
    [super dealloc];
	[segmentedControl release];
	[numbersTable release];
	[lotoArray release];
	[revanchaArray release];
	[pegaCuatroArray release];
	[pegaTresArray release];
	[pegaDosArray release];
}

#pragma mark -
#pragma mark Custom Action Methods

- (void)controlAction:(id)sender {	
	NSIndexPath *segmentIndex = [NSIndexPath indexPathForRow:0 inSection:[segmentedControl selectedSegmentIndex]];
	[self.numbersTable scrollToRowAtIndexPath:segmentIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Custom Methods

- (void)verifyNumbers {
	[lotoArray removeAllObjects];
	[revanchaArray removeAllObjects];
	[pegaCuatroArray removeAllObjects];
	[pegaTresArray removeAllObjects];
	[pegaDosArray removeAllObjects];
	
	LotterySix *winningLoto = [lotteryData.latestNumbers objectForKey:LotoKey];
	LotterySix *winningRevancha = [lotteryData.latestNumbers objectForKey:RevanchaKey];
	LotterySix *myLoto = nil;
	
	for (NSInteger i = 0; i < [lotteryData.lotoNumbers count]; i++) {
		myLoto = [lotteryData.lotoNumbers objectAtIndex:i];
		
		NSArray *lotoHits = [[NSArray alloc] initWithArray:[myLoto hitsForNumbers:[winningLoto winningNumbers]]];
		if ([lotoHits count] > 0) {
			[lotoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  lotoHits, @"hitArrayKey",
								  myLoto, @"lotteryObjectKey",
								  nil]];
		}
		[lotoHits release];
		
		if ([myLoto bonusPlay] == YES) {
			NSArray *revanchaHits = [[NSArray alloc] initWithArray:[myLoto hitsForNumbers:[winningRevancha winningNumbers]]];
			if ([revanchaHits count] > 0) {
				[revanchaArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										  revanchaHits, @"hitArrayKey",
										  myLoto, @"lotteryObjectKey",
										  nil]];				
			}
			[revanchaHits release];
		}
	}
	
	LotteryFour *winningPegaCuatro = [lotteryData.latestNumbers objectForKey:PegaCuatroKey];
	LotteryFour *myPegaCuatro = nil;
	for (NSInteger i = 0; i < [lotteryData.pegaCuatroNumbers count]; i++) {
		myPegaCuatro = [lotteryData.pegaCuatroNumbers objectAtIndex:i];
		LotteryPlayType cuatroPlayType = [self validateWinning:[winningPegaCuatro winningNumbers] withLottery:(Lottery *)myPegaCuatro];
		if (cuatroPlayType != LotteryPlayTypeNone) {			
			[pegaCuatroArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										myPegaCuatro, @"lotteryObjectKey",
										[NSNumber numberWithInt:cuatroPlayType], @"playTypeKey",
										nil]];
		}
	}
	
	LotteryThree *winningPegaTres = [lotteryData.latestNumbers objectForKey:PegaTresKey];
	LotteryThree *myPegaTres = nil;
	for (NSInteger i = 0; i < [lotteryData.pegaTresNumbers count]; i++) {
		myPegaTres = [lotteryData.pegaTresNumbers objectAtIndex:i];
		LotteryPlayType tresPlayType = [self validateWinning:[winningPegaTres winningNumbers] withLottery:(Lottery *)myPegaTres];
		if (tresPlayType != LotteryPlayTypeNone) {
			[pegaTresArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										myPegaTres, @"lotteryObjectKey",
										[NSNumber numberWithInt:tresPlayType], @"playTypeKey",
										nil]];
		}
	}
	
	LotteryTwo *winningPegaDos = [lotteryData.latestNumbers objectForKey:PegaDosKey];
	LotteryTwo *myPegaDos = nil;
	for (NSInteger i = 0; i < [lotteryData.pegaDosNumbers count]; i++) {
		myPegaDos = [lotteryData.pegaDosNumbers objectAtIndex:i];
		LotteryPlayType dosPlayType = [self validateWinning:[winningPegaDos winningNumbers] withLottery:(Lottery *)myPegaDos];
		if (dosPlayType != LotteryPlayTypeNone) {			
			[pegaDosArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										myPegaDos, @"lotteryObjectKey",
										[NSNumber numberWithInt:dosPlayType], @"playTypeKey",
										nil]];
		}
	}
	[numbersTable reloadData];
}

- (BOOL)numbers:(NSArray *)numbers haveExactPrizeFor:(NSArray *)winning {
	NSString *winningString = [[NSString alloc] initWithString:[winning componentsJoinedByString:@""]];
	NSString *numbersString = [[NSString alloc] initWithString:[numbers componentsJoinedByString:@""]];
	BOOL returnBool;
	if ([winningString isEqual:numbersString]) {
		returnBool = YES;
	} else {
		returnBool = NO;
	}
	[winningString release];
	[numbersString release];
	return returnBool;
}

- (BOOL)numbers:(NSArray *)numbers haveCombinedPrizeFor:(NSArray *)winning {
	NSSet *winningSet = [[NSSet alloc] initWithArray:winning];
	NSSet *numbersSet = [[NSSet alloc] initWithArray:numbers];
	BOOL returnBool;
	if ([winningSet isEqualToSet:numbersSet]) {
		returnBool = YES;
	} else {
		returnBool = NO;
	}
	[winningSet release];
	[numbersSet release];
	return returnBool;
}

- (int)validateWinning:(NSArray *)winning withLottery:(Lottery *)lottery {
	BOOL wonExact = NO;
	BOOL wonCombined = NO;
	
	LotteryPlayType tmpPlayType = LotteryPlayTypeNone;
	
	if ([lottery playType] == LotteryPlayTypeExact) {
		wonExact = [self numbers:[lottery winningNumbers] haveExactPrizeFor:winning];
		wonCombined = NO;
	} else if ([lottery playType] == LotteryPlayTypeCombined) {
		wonExact = NO;
		wonCombined = [self numbers:[lottery winningNumbers] haveCombinedPrizeFor:winning];
	} else if ([lottery playType] == LotteryPlayTypeExactCombined) {
		wonExact = [self numbers:[lottery winningNumbers] haveExactPrizeFor:winning];
		wonCombined = [self numbers:[lottery winningNumbers] haveCombinedPrizeFor:winning];
	}
	
	if (wonExact == YES || wonCombined == YES) {
		if (wonExact) {
			tmpPlayType = LotteryPlayTypeExact;
		} else {
			tmpPlayType = LotteryPlayTypeCombined;
		}
	} 
	return tmpPlayType;
}

#pragma mark -
#pragma mark  UITable View Methods

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		currentArray = lotoArray;
	} else if (indexPath.section == 1) {
		currentArray = revanchaArray;
	} else if (indexPath.section == 2) {
		currentArray = pegaCuatroArray;
	} else if (indexPath.section == 3) {
		currentArray = pegaTresArray;
	} else {
		currentArray = pegaDosArray;
	}
	
	UITableViewCell *cell = nil;
	
	if (indexPath.row == 0) {
		NSString *verifyCellIdentifier = @"VerifyCell";
		VerifyCell *verifyCell = (VerifyCell *)[self.numbersTable dequeueReusableCellWithIdentifier:verifyCellIdentifier];
		if (verifyCell == nil) {
			verifyCell = [[[VerifyCell alloc] initWithStyle:UITableViewCellStyleSubtitle
													 reuseIdentifier:verifyCellIdentifier] autorelease];
		}
		
		NSString *latestKey = nil;
		if (indexPath.section == 0) {
			[verifyCell setLoto];
			latestKey = LotoKey;
		} else if (indexPath.section == 1) {
			[verifyCell setRevancha];
			latestKey = RevanchaKey;
		} else if (indexPath.section == 2) {
			[verifyCell setPegaCuatro];
			latestKey = PegaCuatroKey;
		} else if (indexPath.section == 3) {
			[verifyCell setPegaTres];
			latestKey = PegaTresKey;
		} else {
			[verifyCell setPegaDos];
			latestKey = PegaDosKey;
		}
		
		Lottery *latestLottery = [lotteryData.latestNumbers objectForKey:latestKey];
		[verifyCell setDateLabel:[latestLottery drawDate]];
		[verifyCell setUpdateLabel:lotteryData.latestUpdate];
		
		if (indexPath.section == 0 || indexPath.section == 1) {
			[verifyCell.numbersView setBallViewWithNumbers:[(LotterySix *)latestLottery winningNumbers]];
		} else {
			[verifyCell.numbersView setBallViewWithNumbers:[latestLottery winningNumbers]];
		}
		
		cell = (UITableViewCell *)verifyCell;
	} else {
		if ([currentArray count] == 0) {
			static NSString *emptyCellIdentifier = @"EmptyCell";
			UITableViewCell *emptyCell = [self.numbersTable dequeueReusableCellWithIdentifier:emptyCellIdentifier];
			if (emptyCell == nil) {
				emptyCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													  reuseIdentifier:emptyCellIdentifier] autorelease];
			}
			emptyCell.textLabel.textAlignment =  UITextAlignmentCenter;
			emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
			emptyCell.textLabel.text = @"No hay números acertados...";
			cell = emptyCell;
		} else {
			static NSString *lotteryCellIdentifier = @"LotteryCell";
			LotteryNumbersCell *lotteryCell = (LotteryNumbersCell *)[self.numbersTable dequeueReusableCellWithIdentifier:lotteryCellIdentifier];
			if (lotteryCell == nil) {
				lotteryCell = [[[LotteryNumbersCell alloc] initWithStyle:UITableViewCellStyleSubtitle
													  reuseIdentifier:lotteryCellIdentifier] autorelease];
			}
			
			NSDictionary *lotteryDictionary = [currentArray objectAtIndex:indexPath.row - 1];
			Lottery *currentLottery = [lotteryDictionary objectForKey:@"lotteryObjectKey"];
			NSString *subtitleString = nil;
						
			if (indexPath.section == 0 || indexPath.section == 1) {
				NSArray *currentHits = [lotteryDictionary objectForKey:@"hitArrayKey"];
				currentLottery = (LotterySix *)currentLottery;
				
				LotteryBallColorType hitColor = LotteryBallColorMagenta;
				if (indexPath.section == 1) {
					hitColor = LotteryBallColorSalmon;
				}
				
				[lotteryCell.numbersView setLotteryType:LotteryTypeSix];
				[lotteryCell.numbersView setBallColor:LotteryBallColorWhite];
				[lotteryCell.numbersView setBallViewWithNumbers:[(LotterySix *)currentLottery winningNumbers] andHits:currentHits hitColor:hitColor];
				
				subtitleString = [NSString stringWithFormat:@"Números Acertados: %d", [currentHits count]];
				lotteryCell.detailTextLabel.text = subtitleString;
			} else {
				LotteryType lotteryType;
				LotteryBallColorType colorType;
				if (indexPath.section == 2) {
					lotteryType = LotteryTypeFour;
					colorType = LotteryBallColorBlue;
				} else if (indexPath.section == 3) {
					lotteryType = LotteryTypeThree;
					colorType = LotteryBallColorRed;
				} else {
					lotteryType = LotteryTypeTwo;
					colorType = LotteryBallColorOrange;
				}
				
				LotteryPlayType playType = [[lotteryDictionary objectForKey:@"playTypeKey"] intValue];
				NSString *playString = nil;
				if (playType == LotteryPlayTypeExact) {
					playString = [NSString stringWithFormat:@"Exacta"];
				} else {
					playString = [NSString stringWithFormat:@"Combinada"];
					colorType = LotteryBallColorYellow;
				}
				
				[lotteryCell.numbersView setLotteryType:lotteryType];
				[lotteryCell.numbersView setBallColor:colorType];
				[lotteryCell.numbersView setBallViewWithNumbers:[(Lottery *)currentLottery winningNumbers]];

				subtitleString = [NSString stringWithFormat:@"Jugada: %@", playString];
				lotteryCell.detailTextLabel.text = subtitleString;
			}
			cell = (UITableViewCell *)lotteryCell;
		}
	}
	return cell;
}

#pragma mark UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger totalRows = 2;
	if (section == 0 && [lotoArray count] > 0) {
		totalRows = [lotoArray count] + 1;
	} else if (section == 1 && [revanchaArray count] > 0) {
		totalRows = [revanchaArray count] + 1;
	} else if (section == 2 && [pegaCuatroArray count] > 0) {
		totalRows = [pegaCuatroArray count] + 1;
	} else if (section == 3 && [pegaTresArray count] > 0) {
		totalRows = [pegaTresArray count] + 1;
	} else if (section == 4 && [pegaDosArray count] > 0) {
		totalRows = [pegaDosArray count] + 1;
	}
	return totalRows;
}

#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat heightReturn;
	if (indexPath.row == 0) {
		heightReturn = 116.0;
	} else {
		heightReturn = 66.0;
	}
	return heightReturn;
}

@end
