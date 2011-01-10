//
//  PickerNumbers.h
//  LotteryPR
//
//  Created by Axel Rivera on 12/30/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PickerNumbers : UIView {
	UIImageView *numbersImageView;
	NSMutableArray *numbersLabelArray;
}

@property (nonatomic, retain) UIImageView *numbersImageView;
@property (nonatomic, copy) NSMutableArray *numbersLabelArray;

- (id)initWithSize:(NSInteger)size;

- (UILabel *)numberLabel:(NSNumber *)num withPoint:(CGPoint)pt;

- (void)addNumberLabelsWithNumbers:(NSMutableArray *)numArray;
- (void)removeLabelsFromSuperview;

@end
