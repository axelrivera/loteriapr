    //
//  PickSixViewController.m
//  LotteryPR
//
//  Created by arn on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"
#import "NSMutableArray+Shuffle.h"
#import "PickerNumbers.h"

#define LOTO_RANGE 6
#define LOTO_MIN 1
#define LOTO_MAX 46

#define PEGA_CUATRO_RANGE 4
#define PEGA_TRES_RANGE 3
#define PEGA_DOS_RANGE 2

#define LOTTERY_MIN 0
#define LOTTERY_MAX 9

#define SHUFFLE_COUNT 10

@implementation PickerViewController

@synthesize lotteryName;
@synthesize sixPickerView;
@synthesize fourPickerView;
@synthesize threePickerView;
@synthesize twoPickerView;
@synthesize currentPicker;
@synthesize shakeButton;
@synthesize numbersImageView;
@synthesize lotoPickerArray;
@synthesize lotteryPickerArray;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([lotteryName isEqualToString:LotoTitle]) {
		self.title = LotoTitle;
		[self showPicker:sixPickerView];
		[self showLabelView:sixLabelView];
	} else if ([lotteryName isEqualToString:PegaCuatroTitle]) {
		self.title = PegaCuatroTitle;
		[self showPicker:fourPickerView];
		[self showLabelView:fourLabelView];
	} else if ([lotteryName isEqualToString:PegaTresTitle]) {
		self.title = PegaTresTitle;
		[self showPicker:threePickerView];
		[self showLabelView:threeLabelView];
	} else {
		self.title = PegaDosTitle;
		[self showPicker:twoPickerView];
		[self showLabelView:twoLabelView];
	}
	
	[self performSelector:@selector(shakePicker:) withObject:nil afterDelay:1];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	currentPicker.hidden = YES;
	currentLabelView.hidden = YES;
	[self resetCurrentPicker];
	[currentLabelView removeLabelsFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"red_button.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	[shakeButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImagePressed = [UIImage imageNamed:@"blue_button.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	[shakeButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	
	[shakeButton setTitle:@"Lotería Automática" forState:UIControlStateNormal];
	shakeButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[self setupLottery];
	
	// The labels get hidden by default with init method
	sixLabelView = [[PickerNumbers alloc] initWithSize:6];
	[numbersImageView addSubview:sixLabelView];
	
	fourLabelView = [[PickerNumbers alloc] initWithSize:4];
	[numbersImageView addSubview:fourLabelView];
	
	threeLabelView = [[PickerNumbers alloc] initWithSize:3];
	[numbersImageView addSubview:threeLabelView];
	
	twoLabelView = [[PickerNumbers alloc] initWithSize:2];
	[numbersImageView addSubview:twoLabelView];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

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

- (IBAction)shakePicker:(id)sender {
	NSMutableArray *numbersLabelArray = [[NSMutableArray alloc] init];
	
	if (currentPicker == sixPickerView) {
		// In a Loto array numbers cannot be repeated. That's why we only load the array and shuffle just once.
		NSMutableArray *lotoArray = [self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX];
		
		[lotoArray shuffleWithCount:SHUFFLE_COUNT];
		
		for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
			// Substract 1 to the row because Loto starts at 1 instead of 0
			[currentPicker selectRow:[[lotoArray objectAtIndex:i] integerValue] - 1 inComponent:i animated:YES];
			[numbersLabelArray addObject:[lotoArray objectAtIndex:i]];
		}
		
		[lotoArray release];
	} else {
		// In all the other games the numbers can be repeated. We create and shuffle the array at every iteration.
		for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
			NSMutableArray *lotteryArray = [self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX];
			[lotteryArray shuffleWithCount:SHUFFLE_COUNT];
			[currentPicker selectRow:[[lotteryArray objectAtIndex:i] integerValue] inComponent:i animated:YES];
			[numbersLabelArray addObject:[lotteryArray objectAtIndex:i]];
			[lotteryArray release];
		}
	}
	[self performSelector:@selector(setupNumbersLabelWithArray:) withObject:numbersLabelArray afterDelay:1];
	//[self setupNumbersLabelWithArray:numbersLabelArray];
	[numbersLabelArray release];
}

- (void)resetCurrentPicker {
	for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
		[currentPicker selectRow:0 inComponent:i animated:NO];
	}
}

- (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax {
	NSMutableArray *localArray = [[NSMutableArray alloc] initWithCapacity:localMax];
	for (NSInteger i = localMin; i <= localMax; i++) {
		[localArray addObject:[NSNumber numberWithInteger:i]]; 
	}
	return localArray;	
}

- (void) setupLottery {
	lotoPickerArray = [self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX];
	lotteryPickerArray = [self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX];
	
	if (sixPickerView == nil) {
		sixPickerView = [self createPicker];
		[self.view addSubview:sixPickerView];
	}
	
	if (fourPickerView == nil) {
		fourPickerView = [self createPicker];
		[self.view addSubview:fourPickerView];
	}
	
	if (threePickerView == nil) {
		threePickerView = [self createPicker];
		[self.view addSubview:threePickerView];
	}
	
	if (twoPickerView == nil) {
		twoPickerView = [self createPicker];
		[self.view addSubview:twoPickerView];
	}
}

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
	UIPickerView *localPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	CGSize pickerSize = [localPickerView sizeThatFits:CGSizeZero];
	localPickerView.frame = [self pickerFrameWithSize:pickerSize];
	
	localPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	localPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	
	// this view controller is the data source and delegate
	localPickerView.delegate = self;
	localPickerView.dataSource = self;
	
	// add this picker to our view controller, initially hidden
	localPickerView.hidden = YES;
	return localPickerView;
}

- (void)showPicker:(UIPickerView *)picker {
	// hide the current picker and show the new one
	if (currentPicker) {
		currentPicker.hidden = YES;
	}
	picker.hidden = NO;
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void)showLabelView:(PickerNumbers *)label {
	// hide the current picker and show the new one
	if (currentLabelView) {
		currentLabelView.hidden = YES;
	}
	label.hidden = NO;
	currentLabelView = label;	// remember the current picker so we can remove it later when another one is chosen
}

- (void)setupNumbersLabelWithArray:(NSMutableArray *)components {
	NSLog(@"Components for Label; %@", components);
	[currentLabelView addNumberLabelsWithNumbers:components];
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
	[sixPickerView release];
	sixPickerView = nil;
	[fourPickerView release];
	fourPickerView = nil;
	[threePickerView release];
	threePickerView = nil;
	[twoPickerView release];
	twoPickerView = nil;
	
	shakeButton = nil;
	numbersImageView = nil;
	
	self.lotoPickerArray = nil;
	self.lotteryPickerArray = nil;
	
	[sixLabelView release];
	sixLabelView = nil;
	[fourLabelView release];
	fourLabelView = nil;
	[threeLabelView release];
	threeLabelView = nil;
	[twoLabelView release];
	twoLabelView = nil;
}


- (void)dealloc {
    [super dealloc];
	[lotteryName release];
	[sixPickerView release];
	[fourPickerView release];
	[threePickerView release];
	[twoPickerView release];
	[shakeButton release];
	[numbersImageView release];
	[lotoPickerArray release];
	[lotteryPickerArray release];
	[sixLabelView release];
	[fourLabelView release];
	[threeLabelView release];
	[twoLabelView release];
}


@end