//
//  PickSixViewController.h
//  LotteryPR
//
//  Created by arn on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class PickerNumbers;

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAccelerometerDelegate> {
	NSString *lotteryName;
	
	UIPickerView *sixPickerView;
	UIPickerView *fourPickerView;
	UIPickerView *threePickerView;
	UIPickerView *twoPickerView;
	UIPickerView *currentPicker;
	
	UIButton *shakeButton;
	UIImageView *numbersImageView;
	
	NSArray *lotoPickerArray;
	NSArray *lotteryPickerArray;
	
	PickerNumbers *sixLabelView;
	PickerNumbers *fourLabelView;
	PickerNumbers *threeLabelView;
	PickerNumbers *twoLabelView;
	PickerNumbers *currentLabelView;
}

@property (nonatomic, copy) NSString *lotteryName;

@property (nonatomic, retain) UIPickerView *sixPickerView;
@property (nonatomic, retain) UIPickerView *fourPickerView;
@property (nonatomic, retain) UIPickerView *threePickerView;
@property (nonatomic, retain) UIPickerView *twoPickerView;
@property (nonatomic, retain) UIPickerView *currentPicker;

@property (nonatomic, retain) IBOutlet UIButton *shakeButton;
@property (nonatomic, retain) IBOutlet UIImageView *numbersImageView;

@property (nonatomic, copy) NSArray *lotoPickerArray;
@property (nonatomic, copy) NSArray *lotteryPickerArray;

- (IBAction)shakePicker:(id)sender;

- (NSMutableArray *)lotteryArrayWithMin:(NSInteger)localMin max:(NSInteger)localMax;

- (void)setupLottery;

- (UIPickerView *)createPicker;

- (void)showPicker:(UIView *)picker;

- (void)showLabelView:(PickerNumbers *)label;

- (void)resetCurrentPicker;

- (void)setupNumbersLabelWithArray:(NSMutableArray *)components;

@end
