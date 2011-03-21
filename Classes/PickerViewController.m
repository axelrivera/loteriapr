//
//  PickSixViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "PickerViewController.h"
#import "AddNumberViewController.h"
#import "AboutViewController.h"
#import "NSMutableArray+Shuffle.h"
#import "LotteryBallView.h"
#import "LotteryData.h"
#import "InAppPurchaseObserver.h"

@implementation PickerViewController

@synthesize lotteryName;
@synthesize numbersArray;
@synthesize currentPicker, sixPickerView, fourPickerView, threePickerView, twoPickerView;
@synthesize shakeButton;
@synthesize lotoPickerArray, lotteryPickerArray;
@synthesize rememberNumbers;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	LotteryBallColorType colorType;
	LotteryType lotteryType;
	if ([lotteryName isEqualToString:LotoTitle]) {
		self.title = LotoTitle;
		[self showPicker:sixPickerView];
		lotteryType = LotteryTypeSix;
		colorType = LotteryBallColorMagenta;
	} else if ([lotteryName isEqualToString:PegaCuatroTitle]) {
		self.title = PegaCuatroTitle;
		[self showPicker:fourPickerView];
		lotteryType = LotteryTypeFour;
		colorType = LotteryBallColorBlue;
	} else if ([lotteryName isEqualToString:PegaTresTitle]) {
		self.title = PegaTresTitle;
		[self showPicker:threePickerView];
		lotteryType = LotteryTypeThree;
		colorType = LotteryBallColorRed;
	} else {
		self.title = PegaDosTitle;
		[self showPicker:twoPickerView];
		lotteryType = LotteryTypeTwo;
		colorType = LotteryBallColorOrange;
	}
	
	[lotteryBallView setLotteryType:lotteryType];
	[lotteryBallView setBallColor:colorType];
	
	CGRect ballFrame = [lotteryBallView frame];
	ballFrame.origin.x = ([[UIScreen mainScreen] bounds].size.width / 2.0) - (ballFrame.size.width / 2.0);
	ballFrame.origin.y = (114.0 - LOTTERY_BALL_SIZE) / 2.0;
	[lotteryBallView setFrame:ballFrame];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	if (rememberNumbers) {
		[self setupNumbersLabelWithArray:self.numbersArray];
		for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
			NSInteger lotteryIndex;
			lotteryIndex = [[self.numbersArray objectAtIndex:i] integerValue];
			if ([self.numbersArray count] == 6) {
				lotteryIndex--;
			}
			[currentPicker selectRow:lotteryIndex inComponent:i animated:NO];
		}
		self.rememberNumbers = NO;
	} else {
		self.numbersArray = [NSArray array];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	currentPicker.hidden = YES;
	[self resetCurrentPicker];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.tag = 100;
	
	lotteryData = [LotteryData sharedLotteryData];
	self.rememberNumbers = NO;
		
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(addNumber:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"red_button.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	[shakeButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImagePressed = [UIImage imageNamed:@"blue_button.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	[shakeButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	
	[shakeButton setTitle:@"Comenzar" forState:UIControlStateNormal];
	shakeButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[self setupLottery];
	
	lotteryBallView = [[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite];
	[self.view addSubview:lotteryBallView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.sixPickerView = nil;
	self.fourPickerView = nil;
	self.threePickerView = nil;
	self.twoPickerView = nil;
	
	self.shakeButton = nil;
	
	self.lotoPickerArray = nil;
	self.lotteryPickerArray = nil;
	[lotteryBallView release];
	lotteryBallView = nil;
}

- (void)dealloc {
    [super dealloc];
	[lotteryName release];
	[sixPickerView release];
	[fourPickerView release];
	[threePickerView release];
	[twoPickerView release];
	[shakeButton release];
	[lotoPickerArray release];
	[lotteryPickerArray release];
	[lotteryBallView release];
	[numbersArray release];
}

#pragma mark -
#pragma mark UIPickerView Data Source

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *returnStr = @"";
	if (pickerView == sixPickerView) {
		returnStr = [[lotoPickerArray objectAtIndex:row] stringValue];
	} else {
		returnStr = [[lotteryPickerArray objectAtIndex:row] stringValue];
	}
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 45.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger returnCount = 0;
	if (pickerView == sixPickerView) {
		returnCount = [lotoPickerArray count];
	} else {
		returnCount = [lotteryPickerArray count];
	}
	return returnCount;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	NSInteger returnCount = 0;
	if (pickerView == sixPickerView) {
		returnCount = LOTO_RANGE;
	} else if (pickerView == fourPickerView) {
		returnCount = PEGA_CUATRO_RANGE;
	} else if (pickerView == threePickerView) {
		returnCount = PEGA_TRES_RANGE;
	} else {
		returnCount = PEGA_DOS_RANGE;
	}
	return returnCount;
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)addNumber:(id)sender {
	if (![lotteryData canAddNumbers]) {
		if ([[InAppPurchaseObserver sharedInAppPurchase] isPremium]) {
			[self showPremiumAlert];
		} else {
			[self showFreeAlert];
		}
		return;
	}
	
	self.rememberNumbers = YES;
	AddNumberViewController *controller = [[AddNumberViewController alloc] initWithNibName:@"AddNumberViewController"
																					bundle:nil];	
	[controller setCurrentGame:lotteryName];
	[controller setCurrentPickerComponents:self.numbersArray];
	[controller setPickerViewController:self];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (IBAction)shakePicker:(id)sender {
	NSMutableArray *numbersLabelArray = [[NSMutableArray alloc] init];
	
	if (currentPicker == sixPickerView) {
		// In a Loto array numbers cannot be repeated. That's why we only load the array and shuffle just once.
		NSMutableArray *lotoArray = [[self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX] retain];
		
		[lotoArray shuffleWithCount:SHUFFLE_COUNT];
		
		NSInteger lotoIndex;
		for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
			// Substract 1 to the row because Loto starts at 1 instead of 0
			lotoIndex = [[lotoArray objectAtIndex:i] integerValue];
			[currentPicker selectRow:lotoIndex - 1 inComponent:i animated:YES];
			[numbersLabelArray addObject:[lotoArray objectAtIndex:i]];
		}
		
		[lotoArray release];
	} else {
		// In all the other games the numbers can be repeated. We create and shuffle the array at every iteration.
		for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
			NSMutableArray *lotteryArray = [[self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX] retain];
			[lotteryArray shuffleWithCount:SHUFFLE_COUNT];
			[currentPicker selectRow:[[lotteryArray objectAtIndex:i] integerValue] inComponent:i animated:YES];
			[numbersLabelArray addObject:[lotteryArray objectAtIndex:i]];
			[lotteryArray release];
		}
	}
	[self performSelector:@selector(setupNumbersLabelWithArray:) withObject:numbersLabelArray afterDelay:0.5];
	self.numbersArray = numbersLabelArray;
	[numbersLabelArray release];
}

#pragma mark -
#pragma mark Class Methods

- (void)setupNumbersLabelWithArray:(NSArray *)array {
	[lotteryBallView setBallViewWithNumbers:array];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)showFreeAlert {
	NSString *messageString = [NSString stringWithFormat:@"La versión Gratis de Loteria Puerto Rico te permite "
							   "guardar un máximo de %d números. ¿Deseas comprar la versión Premium para "
							   "poder guardar más números?", MAX_FREE_NUMBERS];
	
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

#pragma mark Lottery Methods

- (void) setupLottery {
	lotoPickerArray = [[self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX] retain];
	lotteryPickerArray = [[self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX] retain];
	
	if (sixPickerView == nil) {
		sixPickerView = [[self createPicker] retain];
		[self.view addSubview:sixPickerView];
	}
	
	if (fourPickerView == nil) {
		fourPickerView = [[self createPicker] retain];
		[self.view addSubview:fourPickerView];
	}
	
	if (threePickerView == nil) {
		threePickerView = [[self createPicker] retain];
		[self.view addSubview:threePickerView];
	}
	
	if (twoPickerView == nil) {
		twoPickerView = [[self createPicker] retain];
		[self.view addSubview:twoPickerView];
	}
}

- (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax {
	NSMutableArray *localArray = [[[NSMutableArray alloc] initWithCapacity:localMax] autorelease];
	for (NSInteger i = localMin; i <= localMax; i++) {
		NSNumber *tmpNumber = [[[NSNumber alloc] initWithInteger:i] autorelease];
		[localArray addObject:tmpNumber]; 
	}
	return localArray;	
}

#pragma mark Picker Methods

- (void)showPicker:(UIPickerView *)picker {
	// hide the current picker and show the new one
	if (currentPicker) {
		currentPicker.hidden = YES;
	}
	picker.hidden = NO;
	
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void)resetCurrentPicker {
	for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
		[currentPicker selectRow:0 inComponent:i animated:NO];
	}
}

#pragma mark -
#pragma mark Lazy Creation of UIPickerView

- (CGRect)pickerFrameWithSize:(CGSize)size {
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
								   screenRect.size.height - (86.0 + 44.0 + size.height),
								   size.width,
								   size.height);
	return pickerRect;
}

- (UIPickerView *)createPicker {
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	UIPickerView *localPickerView = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
	CGSize pickerSize = [localPickerView sizeThatFits:CGSizeZero];
	localPickerView.frame = [self pickerFrameWithSize:pickerSize];
	localPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	localPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	localPickerView.userInteractionEnabled = NO;
	
	// this view controller is the data source and delegate
	localPickerView.delegate = self;
	localPickerView.dataSource = self;
	
	// add this picker to our view controller, initially hidden
	localPickerView.hidden = YES;
	return localPickerView;
}

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([@"OK" isEqualToString:[alertView buttonTitleAtIndex:buttonIndex]]) {
		self.rememberNumbers = YES;
		AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
																				bundle:nil];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

@end
