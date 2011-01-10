//
//  PickerNumbers.m
//  LotteryPR
//
//  Created by Axel Rivera on 12/30/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "PickerNumbers.h"

#define BALL_OFFSET 8.0
#define BALL_SIZE 40.0

@implementation PickerNumbers

@synthesize numbersImageView;
@synthesize numbersLabelArray;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithSize:(NSInteger)size {	
	if (size == LOTO_RANGE) {
		numbersImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_loto_circles.png"]];
	} else if (size == PEGA_CUATRO_RANGE) {
		numbersImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_pegacuatro_circles.png"]];
	} else if (size == PEGA_TRES_RANGE) {
		numbersImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_pegatres_circles.png"]];
	} else {
		numbersImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_pegados_circles.png"]];
	}
	
	CGFloat startX = ([[UIScreen mainScreen] bounds].size.width - numbersImageView.bounds.size.width) / 2.0;
	CGFloat startY = (114.0 - numbersImageView.bounds.size.height) / 2.0;

	CGRect frame = CGRectMake(startX, startY, numbersImageView.bounds.size.width, numbersImageView.bounds.size.height);
	
	// Set self's frame to encompass the image
	self = [self initWithFrame:frame];
	
	if (self != nil) {
		self.opaque = NO;
		self.hidden = YES;
		[self addSubview:numbersImageView];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[numbersImageView release];
	[numbersLabelArray release];
}

#pragma mark -
#pragma mark Class Methods

- (UILabel *)numberLabel:(NSNumber *)num withPoint:(CGPoint)pt {
	CGRect labelRect = CGRectMake(pt.x, pt.y, BALL_SIZE, BALL_SIZE);
	UILabel *label = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
	label.textAlignment =  UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(0.0, 1.0);
	label.text = [NSString stringWithFormat:@"%d", [num intValue]];
	return label;
}

- (void)addNumberLabelsWithNumbers:(NSMutableArray *)numArray {
	int positionY = 0.0;
	int positionX = 0.0;
	[self removeLabelsFromSuperview];
	for (int i = 0; i < [numArray count]; i++) {
		if (i > 0) {
			positionX = positionX + BALL_OFFSET + BALL_SIZE;
		}
		[numbersImageView addSubview:[self numberLabel:[numArray objectAtIndex:i] withPoint:CGPointMake(positionX, positionY)]];
	}
}

- (void)removeLabelsFromSuperview {
	for (UIView *localView in numbersImageView.subviews) {
		[localView removeFromSuperview];
	}
}

@end
