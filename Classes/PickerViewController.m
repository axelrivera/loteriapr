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

@interface PickerViewController (Private)

- (void)setupDataSource;
- (void)setupNumbersLabelWithArray:(NSArray *)array;
- (void)showFreeAlert;
- (void)showPremiumAlert;
- (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax;

@end

@implementation PickerViewController

@synthesize pickerView = pickerView_;
@synthesize pickerDataSource = pickerDataSource_;
@synthesize lotteryName;
@synthesize numbersArray;
@synthesize shakeButton;
@synthesize rememberNumbers = rememberNumbers_;
@synthesize pickerType = pickerType_;

- (id)initWithPickerType:(PickerViewType)type
{
    self = [super initWithNibName:@"PickerViewController" bundle:nil];
    if (self) {
        pickerType_ = type;
        lotteryData_ = [LotteryData sharedLotteryData];
        rememberNumbers_ = NO;
        [self setupDataSource];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	LotteryBallColorType colorType;
	LotteryType lotteryType;
	if ([lotteryName isEqualToString:LotoTitle]) {
		self.title = LotoTitle;
		lotteryType = LotteryTypeSix;
		colorType = LotteryBallColorMagenta;
	} else if ([lotteryName isEqualToString:PegaCuatroTitle]) {
		self.title = PegaCuatroTitle;
		lotteryType = LotteryTypeFour;
		colorType = LotteryBallColorBlue;
	} else if ([lotteryName isEqualToString:PegaTresTitle]) {
		self.title = PegaTresTitle;
		lotteryType = LotteryTypeThree;
		colorType = LotteryBallColorRed;
	} else {
		self.title = PegaDosTitle;
		lotteryType = LotteryTypeTwo;
		colorType = LotteryBallColorOrange;
	}
	
	[lotteryBallView_ setLotteryType:lotteryType];
	[lotteryBallView_ setBallColor:colorType];
	
	CGRect ballFrame = [lotteryBallView_ frame];
	ballFrame.origin.x = ([[UIScreen mainScreen] bounds].size.width / 2.0) - (ballFrame.size.width / 2.0);
	ballFrame.origin.y = (114.0 - LOTTERY_BALL_SIZE) / 2.0;
	[lotteryBallView_ setFrame:ballFrame];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	if (rememberNumbers_) {
		[self setupNumbersLabelWithArray:self.numbersArray];
		for (NSInteger i = 0; i < [pickerView_ numberOfComponents]; i++) {
			NSInteger lotteryIndex;
			lotteryIndex = [[self.numbersArray objectAtIndex:i] integerValue];
			if ([self.numbersArray count] == 6) {
				lotteryIndex--;
			}
			[pickerView_ selectRow:lotteryIndex inComponent:i animated:NO];
		}
		rememberNumbers_ = NO;
	} else {
		self.numbersArray = [NSArray array];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.tag = 100;
    
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
	
	lotteryBallView_ = [[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite];
	[self.view addSubview:lotteryBallView_];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.pickerView = nil;
	self.shakeButton = nil;
	[lotteryBallView_ release];
	lotteryBallView_ = nil;
}

- (void)dealloc {
	[lotteryName release];
	[shakeButton release];
	[lotteryBallView_ release];
	[numbersArray release];
    [pickerDataSource_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIPickerView Data Source

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[pickerDataSource_ objectAtIndex:row] stringValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 45.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerDataSource_ count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	NSInteger returnCount = 0;
	if (pickerType_ == PickerViewTypeSix) {
		returnCount = LOTO_RANGE;
	} else if (pickerType_ == PickerViewTypeFour) {
		returnCount = PEGA_CUATRO_RANGE;
	} else if (pickerType_ == PickerViewTypeThree) {
		returnCount = PEGA_TRES_RANGE;
	} else {
		returnCount = PEGA_DOS_RANGE;
	}
	return returnCount;
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)addNumber:(id)sender {
	if (![lotteryData_ canAddNumbers]) {
		if ([[InAppPurchaseObserver sharedInAppPurchase] isPremium]) {
			[self showPremiumAlert];
		} else {
			[self showFreeAlert];
		}
		return;
	}
	
	rememberNumbers_ = YES;
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
	
	if (pickerType_ == PickerViewTypeSix) {
		// In a Loto array numbers cannot be repeated. That's why we only load the array and shuffle just once.
		NSMutableArray *lotoArray = [[self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX] retain];
		
		[lotoArray shuffleWithCount:SHUFFLE_COUNT];
		
		NSInteger lotoIndex;
		for (NSInteger i = 0; i < [pickerView_ numberOfComponents]; i++) {
			// Substract 1 to the row because Loto starts at 1 instead of 0
			lotoIndex = [[lotoArray objectAtIndex:i] integerValue];
			[pickerView_ selectRow:lotoIndex - 1 inComponent:i animated:YES];
			[numbersLabelArray addObject:[lotoArray objectAtIndex:i]];
		}
		
		[lotoArray release];
	} else {
		// In all the other games the numbers can be repeated. We create and shuffle the array at every iteration.
		for (NSInteger i = 0; i < [pickerView_ numberOfComponents]; i++) {
			NSMutableArray *lotteryArray = [[self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX] retain];
			[lotteryArray shuffleWithCount:SHUFFLE_COUNT];
			[pickerView_ selectRow:[[lotteryArray objectAtIndex:i] integerValue] inComponent:i animated:YES];
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
	[lotteryBallView_ setBallViewWithNumbers:array];
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

- (void) setupDataSource {
    if (pickerType_ == PickerViewTypeSix) {
        self.pickerDataSource = [self lotteryArrayWithMin:LOTO_MIN max:LOTO_MAX];
    } else {
        self.pickerDataSource = [self lotteryArrayWithMin:LOTTERY_MIN max:LOTTERY_MAX];
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

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([@"OK" isEqualToString:[alertView buttonTitleAtIndex:buttonIndex]]) {
		rememberNumbers_ = YES;
		AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
																				bundle:nil];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

@end
