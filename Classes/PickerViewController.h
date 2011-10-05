//
//  PickSixViewController.h
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

@class LotteryBallView;
@class LotteryData;

typedef enum
{
    PickerViewTypeSix,
    PickerViewTypeFour,
    PickerViewTypeThree,
    PickerViewTypeTwo
} PickerViewType;

@interface PickerViewController : UIViewController {
	LotteryBallView *lotteryBallView_;
	LotteryData *lotteryData_;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *shakeButton;
@property (nonatomic, copy) NSString *lotteryName;
@property (nonatomic, copy) NSArray *numbersArray;
@property (nonatomic, assign) BOOL rememberNumbers;
@property (nonatomic, assign) PickerViewType pickerType;

@property (nonatomic, copy) NSArray *pickerDataSource;

- (id)initWithPickerType:(PickerViewType)type;

- (IBAction)shakePicker:(id)sender;
- (IBAction)addNumber:(id)sender;

@end
