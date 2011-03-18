    //
//  AddNumberViewController.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "AddNumberViewController.h"
#import "SelectViewController.h"
#import "PickerViewController.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryData.h"

@implementation AddNumberViewController

@synthesize currentPickerComponents;
@synthesize sixPickerView;
@synthesize fourPickerView;
@synthesize threePickerView;
@synthesize twoPickerView;
@synthesize currentPicker;
@synthesize playSwitch;
@synthesize pickerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.pickerViewController = nil;
        lotoPickerArray = [[NSArray alloc] initWithArray:[Lottery lotoBucket]];
		lotteryPickerArray = [[NSArray alloc] initWithArray:[Lottery lotteryBucket]];
		[self setCurrentGame:@"Loto"];
		[self setPlayType:@"Exacta"];
		[self setCurrentPickerComponents:[NSArray array]];
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Añadir";
	
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar"
																		 style:UIBarButtonItemStyleBordered
																		target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
	
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Guardar"
																	   style:UIBarButtonItemStyleDone
																	  target:self action:@selector(done:)];
	self.navigationItem.rightBarButtonItem = doneButtonItem;
	[doneButtonItem release];
	
	playSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	
	[self setupLottery];
	[self resetCurrentPicker];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
	
	if ([currentGame isEqualToString:LotoTitle]) {
		[self showPicker:sixPickerView];
	} else if ([currentGame isEqualToString:PegaCuatroTitle]) {
		[self showPicker:fourPickerView];
	} else if ([currentGame isEqualToString:PegaTresTitle]) {
		[self showPicker:threePickerView];
	} else {
		[self showPicker:twoPickerView];
	}
	
	if ([currentPickerComponents count] > 0 && [currentPicker numberOfComponents] == [currentPickerComponents count]) {
		NSInteger currentComponents = [currentPicker numberOfComponents];
		NSInteger pickerIndex;
		for (NSInteger i = 0; i < currentComponents; i++) {
			if (currentComponents == 6) {
				pickerIndex = [[currentPickerComponents objectAtIndex:i] integerValue] - 1;
			} else {
				pickerIndex = [[currentPickerComponents objectAtIndex:i] integerValue];
			}
			[currentPicker selectRow:pickerIndex inComponent:i animated:NO];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	currentPicker.hidden = YES;
}

#pragma mark Memory Management

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
	self.playSwitch = nil;
}

- (void)dealloc {
	[sixPickerView release];
	[fourPickerView release];
	[threePickerView release];
	[twoPickerView release];
	[lotoPickerArray release];
	[lotteryPickerArray release];
	[playSwitch release];
	[super dealloc];
}

#pragma mark -
#pragma mark Custom Action Methods

- (IBAction)done:(id)sender {
	if ([self saveNumber] == YES) {
		if (self.pickerViewController != nil) {
			self.pickerViewController.rememberNumbers = NO;
		}
		[self dismiss];
	}
}

- (IBAction)cancel:(id)sender {
	[self dismiss];
}

#pragma mark -
#pragma mark Custom Methods

- (void)dismiss {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)setCurrentGame:(NSString *)game {
	currentGame = game;
}

- (void)setPlayType:(NSString *)type {
	playType = type;
}

- (BOOL)saveNumber {	
	NSMutableArray *numbersArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
	NSArray *currentLotteryArray = nil;
	
	if ([currentGame isEqualToString:LotoTitle]) {
		currentLotteryArray = lotoPickerArray;
	} else {
		currentLotteryArray = lotteryPickerArray;
	}

	for (NSInteger i = 0; i < [currentPicker numberOfComponents]; i++) {
		[numbersArray addObject: [currentLotteryArray objectAtIndex:[currentPicker selectedRowInComponent:i]]];
	}
	
	LotteryPlayType lotteryPlayType = LotteryPlayTypeNone;
	if ([playType isEqualToString:@"Exacta"]) {
		lotteryPlayType = LotteryPlayTypeExact;
	} else if ([playType isEqualToString:@"Combinada"]) {
		lotteryPlayType = LotteryPlayTypeCombined;
	} else if ([playType isEqualToString:@"Exacta/Combinada"]) {
		lotteryPlayType = LotteryPlayTypeExactCombined;
	} else {
		lotteryPlayType = LotteryPlayTypeNone;
	}
	
	if ([currentGame isEqualToString:LotoTitle]) {
		if ([LotterySix isValidForNumbers:numbersArray] == NO) {
			[self showInvalidNumber];
			return NO;
		}
		LotterySix *six = [[LotterySix alloc] initWithName:LotoTitle];
		[six setWinningNumbers:[LotterySix orderedArrayFromNumbers:numbersArray]];
		if (playSwitch.on == YES) {
			[six setBonusPlay:YES];
		}
		[[LotteryData sharedLotteryData] addLotoObject:six];
		[six release];
	} else if ([currentGame isEqualToString:PegaCuatroTitle]) {
		LotteryFour *four = [[LotteryFour alloc] initWithName:PegaCuatroTitle];
		[four setWinningNumbers:numbersArray];
		[four setPlayType:lotteryPlayType];
		[[LotteryData sharedLotteryData] addPegaCuatroObject:four];
		[four release];
	} else if ([currentGame isEqualToString:PegaTresTitle]) {
		LotteryThree *three = [[LotteryThree alloc] initWithName:PegaTresTitle];
		[three setWinningNumbers:numbersArray];
		[three setPlayType:lotteryPlayType];
		[[LotteryData sharedLotteryData] addPegaTresObject:three];
		[three release];
	} else if ([currentGame isEqualToString:PegaDosTitle]) {
		LotteryTwo *two = [[LotteryTwo alloc] initWithName:PegaDosTitle];
		[two setWinningNumbers:numbersArray];
		[two setPlayType:lotteryPlayType];
		[[LotteryData sharedLotteryData] addPegaDosObject:two];
		[two release];
	}
	return YES;
}

- (void)showInvalidNumber {
	NSString *message = @"Los números de la Loto no pueden tener duplicados.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Número Inválido"
													message:message
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
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
		
		if (currentGame == LotoTitle) {
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

#pragma mark Lottery Methods

- (void) setupLottery {
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
								   screenRect.size.height - size.height - 44.0,
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
	
	// this view controller is the data source and delegate
	localPickerView.delegate = self;
	localPickerView.dataSource = self;
	
	// add this picker to our view controller, initially hidden
	localPickerView.hidden = YES;
	return localPickerView;
}

@end
