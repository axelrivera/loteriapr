//
//  LotteryNumbersCell.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "LotteryNumbersCell.h"
#import "LotteryBallView.h"

#define VERTICAL_MARGIN 5
#define HORIZONTAL_MARGIN 10
#define FIRST_ROW_HEIGHT 35
#define SECOND_ROW_HEIGHT 16
#define ROW_OFFSET 5	

@implementation LotteryNumbersCell

@synthesize numbersView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		self.detailTextLabel.textColor = [UIColor darkGrayColor];
		[self setNumbersView:[[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite]];
    }
    return self;
}

- (void)layoutSubviews {
	// We always call this, the table view cell needs to do its own work first
	[super layoutSubviews];
	
	CGRect bounds = [[self contentView] bounds];
	
	CGFloat subtitleX = HORIZONTAL_MARGIN;
	CGFloat subtitleY = VERTICAL_MARGIN + FIRST_ROW_HEIGHT + ROW_OFFSET;
	CGFloat subtitleWidth = bounds.size.width - (HORIZONTAL_MARGIN * 2);
	CGFloat subtitleHeight = SECOND_ROW_HEIGHT;
	CGRect subtitleFrame = CGRectMake(subtitleX, subtitleY, subtitleWidth, subtitleHeight);
	[self.detailTextLabel setFrame:subtitleFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNumbersView:(LotteryBallView *)numView {
	if (numView == numbersView) {
		return;
	}
	[numbersView removeFromSuperview];
	[numbersView release];
	numbersView = nil;
	numbersView = [numView retain];
	numbersView = numView;
	if (numbersView != nil) {
		CGRect numbersRect = CGRectMake(HORIZONTAL_MARGIN, VERTICAL_MARGIN, numbersView.bounds.size.width, numbersView.bounds.size.height);
		[numbersView setFrame:numbersRect];
		[[self contentView] addSubview:numbersView];
	}
}

- (void)dealloc {
	[numbersView release];
    [super dealloc];
}


@end
