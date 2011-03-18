//
//  NumbersSelectViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "NumbersSelectViewController.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryBallView.h"

@implementation NumbersSelectViewController

@synthesize descriptionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Número";
	
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
	ballFrame.origin.y = 120.0;
	[lotteryBallView setFrame:ballFrame];	
		
	NSString *descriptionString;
	if ([[currentLottery gameName] isEqualToString:LotoTitle]) {
		if ([(LotterySix *)currentLottery bonusPlay] == YES) {
			descriptionString = @"Con Revancha";
		} else {
			descriptionString = @"Sin Revancha";
		}
	} else {
		if ([currentLottery playType] == LotteryPlayTypeExact) {
			descriptionString = @"Exacta";
		} else if ([currentLottery playType] == LotteryPlayTypeCombined) {
			descriptionString = @"Combinada";
		} else if ([currentLottery playType] == LotteryPlayTypeExactCombined) {
			descriptionString = @"Exacta/Combinada";
		} else {
			descriptionString = @"";
		}
	}

	descriptionLabel.text = descriptionString;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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
	self.descriptionLabel = nil;
	[lotteryBallView release];
	lotteryBallView = nil;
}

- (void)dealloc {
	[descriptionLabel release];
	[lotteryBallView release];
    [super dealloc];
}

- (void)setCurrentLottery:(Lottery *)lottery {
	currentLottery = lottery;
}

@end
