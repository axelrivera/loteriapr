//
//  PickSixViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@class LotteryBallView;
@class LotteryData;

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	NSString *lotteryName;
	NSArray *numbersArray;
	BOOL rememberNumbers;
	
	UIPickerView *sixPickerView;
	UIPickerView *fourPickerView;
	UIPickerView *threePickerView;
	UIPickerView *twoPickerView;
	UIPickerView *currentPicker;
	
	UIButton *shakeButton;
	
	NSArray *lotoPickerArray;
	NSArray *lotteryPickerArray;
	
	LotteryBallView *lotteryBallView;
	LotteryData *lotteryData;
}

@property (nonatomic, copy) NSString *lotteryName;
@property (nonatomic, copy) NSArray *numbersArray;
@property (nonatomic) BOOL rememberNumbers;

@property (nonatomic, retain) UIPickerView *sixPickerView;
@property (nonatomic, retain) UIPickerView *fourPickerView;
@property (nonatomic, retain) UIPickerView *threePickerView;
@property (nonatomic, retain) UIPickerView *twoPickerView;
@property (nonatomic, retain) UIPickerView *currentPicker;

@property (nonatomic, retain) IBOutlet UIButton *shakeButton;

@property (nonatomic, copy) NSArray *lotoPickerArray;
@property (nonatomic, copy) NSArray *lotteryPickerArray;

- (IBAction)shakePicker:(id)sender;

- (UIPickerView *)createPicker;

- (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax;

- (void)setupLottery;
- (IBAction)addNumber:(id)sender;
- (void)showPicker:(UIView *)picker;
- (void)resetCurrentPicker;
- (void)setupNumbersLabelWithArray:(NSArray *)array;
- (void)showFreeAlert;
- (void)showPremiumAlert;

@end
