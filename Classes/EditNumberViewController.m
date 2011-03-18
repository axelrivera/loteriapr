//
//  EditNumberViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "EditNumberViewController.h"
#import "SelectViewController.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryBallView.h"

@implementation EditNumberViewController

@synthesize lotteryTable;
@synthesize playSwitch;
@synthesize start;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self setCurrentGame:@"Loto"];
		[self setPlayType:@"Exacta"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Editar";
	playSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	
	lotteryBallView = [[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite];
	[self.view addSubview:lotteryBallView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSArray *currentNumbers;
	LotteryType lotteryType;
	LotteryBallColorType colorType;
	if ([[currentLottery gameName] isEqualToString:LotoTitle]) {
		currentNumbers = [NSArray arrayWithArray:[(LotterySix *)currentLottery winningNumbers]];
		lotteryType = LotteryTypeSix;
		colorType = LotteryBallColorMagenta;
	} else if ([[currentLottery gameName] isEqualToString:PegaCuatroTitle]) {
		currentNumbers = [NSArray arrayWithArray:[(LotteryFour *)currentLottery winningNumbers]];
		lotteryType = LotteryTypeFour;
		colorType = LotteryBallColorBlue;
	} else if ([[currentLottery gameName] isEqualToString:PegaTresTitle]) {
		currentNumbers = [NSArray arrayWithArray:[(LotteryThree *)currentLottery winningNumbers]];
		lotteryType = LotteryTypeThree;
		colorType = LotteryBallColorRed;
	} else {
		currentNumbers = [NSArray arrayWithArray:[(LotteryTwo *)currentLottery winningNumbers]];
		lotteryType = LotteryTypeTwo;
		colorType = LotteryBallColorOrange;
	}
	
	[lotteryBallView setLotteryType:lotteryType];
	[lotteryBallView setBallColor:colorType];
	[lotteryBallView setBallViewWithNumbers:currentNumbers];
	
	CGRect ballFrame = [lotteryBallView frame];
	ballFrame.origin.x = ([[UIScreen mainScreen] bounds].size.width / 2.0) - (ballFrame.size.width / 2.0);
	ballFrame.origin.y = 25.0;
	[lotteryBallView setFrame:ballFrame];
	
	
	if ([[currentLottery gameName] isEqualToString:LotoTitle]) {
		playSwitch.on = [(LotterySix *)currentLottery bonusPlay];
	}
	
	if (start == YES) {
		NSString *lotteryPlay = nil;
		if ([currentLottery playType] == LotteryPlayTypeExact) {
			lotteryPlay = @"Exacta";
		} else if ([currentLottery playType] == LotteryPlayTypeCombined) {
			lotteryPlay = @"Combinada";
		} else if ([currentLottery playType] == LotteryPlayTypeExactCombined) {
			lotteryPlay = @"Exacta/Combinada";
		} else {
			lotteryPlay = @"";
		}
		[self setPlayType:lotteryPlay];
		[self setStart:NO];
	}
	
	[self.lotteryTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self saveNumber];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.lotteryTable = nil;
	self.playSwitch = nil;
}

- (void)dealloc {
	[lotteryTable release];
	[playSwitch release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods

- (void)setCurrentLottery:(Lottery *)lottery {
	currentLottery = lottery;
}

- (void)setCurrentGame:(NSString *)game {
	currentGame = game;
}

- (void)setPlayType:(NSString *)type {
	playType = type;
}

- (void)saveNumber {
	LotteryPlayType lotteryPlayType = LotteryPlayTypeNone;
	if ([playType isEqualToString:@"Exacta"]) {
		lotteryPlayType = LotteryPlayTypeExact;
	} else if ([playType isEqualToString:@"Combinada"]) {
		lotteryPlayType = LotteryPlayTypeCombined;
	} else if ([playType isEqualToString:@"Exacta/Combinada"]) {
		lotteryPlayType = LotteryPlayTypeExactCombined;
	} else {
		lotteryPlayType = LotteryPlayTypeExact;
	}
	
	if ([[currentLottery gameName] isEqualToString:LotoTitle]) {
		[(LotterySix *)currentLottery setBonusPlay:playSwitch.on];
	} else {
		[currentLottery setPlayType:lotteryPlayType];
	}
}

#pragma mark -
#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *labelString = nil;
	UITableViewCell *cell = nil;
	
	if (indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GameCell"] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		cell.detailTextLabel.text = currentGame;
		labelString = [NSString stringWithFormat:@"Juego"];
	} else {
		if (cell != nil)
			[cell release];
		
		if ([currentGame isEqualToString:LotoTitle]) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayFlagCell"] autorelease];
			cell.accessoryView = playSwitch;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			labelString = [NSString stringWithFormat:@"Revancha"];
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlayTypeCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.detailTextLabel.text = playType;
			labelString = [NSString stringWithFormat:@"Jugada"];
		}
	}
	
	cell.textLabel.text = labelString;
	return cell;
}

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.row == 1 && ![currentGame isEqualToString:LotoTitle]) {
		SelectViewController *controller = [[SelectViewController alloc] initWithNibName:@"SelectViewController"
																				  bundle:nil];
		[controller setCurrentSelect:playType];
		[controller setSelectType:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

@end
