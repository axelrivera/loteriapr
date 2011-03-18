//
//  AddNumberViewController.h
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

@class PickerViewController;

@interface AddNumberViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UISwitch *playSwitch;
	NSString *currentGame;
	NSString *playType;
	NSArray *currentPickerComponents;
	
	UIPickerView *sixPickerView;
	UIPickerView *fourPickerView;
	UIPickerView *threePickerView;
	UIPickerView *twoPickerView;
	UIPickerView *currentPicker;
		
	NSArray *lotoPickerArray;
	NSArray *lotteryPickerArray;
	PickerViewController *pickerViewController;
}

@property (nonatomic, retain) UISwitch *playSwitch;
@property (nonatomic, copy) NSArray *currentPickerComponents;
@property (nonatomic, retain) UIPickerView *sixPickerView;
@property (nonatomic, retain) UIPickerView *fourPickerView;
@property (nonatomic, retain) UIPickerView *threePickerView;
@property (nonatomic, retain) UIPickerView *twoPickerView;
@property (nonatomic, retain) UIPickerView *currentPicker;
@property (nonatomic, assign) PickerViewController *pickerViewController;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)dismiss;
- (UIPickerView *)createPicker;

- (void)setupLottery;
- (void)setCurrentGame:(NSString *)game;
- (void)setPlayType:(NSString *)type;
- (void)showPicker:(UIView *)picker;
- (void)resetCurrentPicker;
- (void)showInvalidNumber;
- (BOOL)saveNumber;

@end
