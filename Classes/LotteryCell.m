//
//  LotteryCell.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "LotteryCell.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryBallView.h"

#define VERTICAL_MARGIN 10
#define HORIZONTAL_MARGIN 10
#define COLUMN_OFFSET 10
#define ROW_HEIGHT 35
#define ROW_OFFSET 10
#define LOGO_WIDTH 100	

@implementation LotteryCell

@synthesize numbersView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		
		// Date Formatter Settings
		dateFormatter = [[NSDateFormatter alloc] init];
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_US"];
		
		[dateFormatter setLocale: usLocale];
		[usLocale release];
		
		//[formatter setTimeZone:[NSTimeZone systemTimeZone]];
		// The original date string was in GMT
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		[dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
		
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[dateLabel setTextColor:[UIColor darkGrayColor]];
		[dateLabel setTextAlignment:UITextAlignmentRight];
		[[self contentView] addSubview:dateLabel];
		
		logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:logoView];
		
        // Tell the imageview to resize its image to fit inside its frame
        [logoView setContentMode:UIViewContentModeLeft];
		
        LotteryBallView *ballView = [[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite];
		[self setNumbersView:ballView];
        [ballView release];
		[self.contentView addSubview:numbersView];
    }
    return self;
}

- (void)layoutSubviews {
	// We always call this, the table view cell needs to do its own work first
	[super layoutSubviews];
	
	CGRect bounds = [[self contentView] bounds];
	
	CGRect logoFrame = CGRectMake(HORIZONTAL_MARGIN, VERTICAL_MARGIN, LOGO_WIDTH, ROW_HEIGHT);
	[logoView setFrame:logoFrame];
	
	CGFloat dateOffset = (HORIZONTAL_MARGIN * 2) + LOGO_WIDTH + COLUMN_OFFSET;
	CGFloat dateWidth = bounds.size.width - dateOffset;
	CGFloat dateHeight = ROW_HEIGHT;
	CGFloat dateX = HORIZONTAL_MARGIN + LOGO_WIDTH + COLUMN_OFFSET;
	CGFloat dateY = VERTICAL_MARGIN;
	
	CGRect dateFrame = CGRectMake(dateX, dateY, dateWidth, dateHeight);
	[dateLabel setFrame:dateFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
}

- (void)dealloc {
	[dateLabel release];
	[logoView release];
	[numbersView release];
	[dateFormatter release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Instance Methods

- (void)setLoto:(LotterySix *)lottery {
	[logoView setImage:[UIImage imageNamed:@"loto.png"]];
	[self setDateLabel:[lottery drawDate]];
	[numbersView setLotteryType:LotteryTypeSix];
	[numbersView setBallViewWithNumbers:[lottery winningNumbers]];
}

- (void)setRevancha:(LotterySix *)lottery {
	[logoView setImage:[UIImage imageNamed:@"revancha.png"]];
	[self setDateLabel:[lottery drawDate]];
	[numbersView setLotteryType:LotteryTypeSix];
	[numbersView setBallViewWithNumbers:[lottery winningNumbers]];
}

- (void)setPegaCuatro:(LotteryFour *)lottery {
	[logoView setImage:[UIImage imageNamed:@"pegacuatro.png"]];
	[self setDateLabel:[lottery drawDate]];
	[numbersView setLotteryType:LotteryTypeFour];
	[numbersView setBallViewWithNumbers:[lottery winningNumbers]];
}

- (void)setPegaTres:(LotteryThree *)lottery {
	[logoView setImage:[UIImage imageNamed:@"pegatres.png"]];
	[self setDateLabel:[lottery drawDate]];
	[numbersView setLotteryType:LotteryTypeThree];
	[numbersView setBallViewWithNumbers:[lottery winningNumbers]];
}

- (void)setPegaDos:(LotteryTwo *)lottery {
	[logoView setImage:[UIImage imageNamed:@"pegados.png"]];
	[self setDateLabel:[lottery drawDate]];
	[numbersView setLotteryType:LotteryTypeTwo];
	[numbersView setBallViewWithNumbers:[lottery winningNumbers]];
}

- (void)setDateLabel:(NSDate *)date {
	[dateLabel setText:[dateFormatter stringFromDate:date]];
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
		CGFloat numbersX = HORIZONTAL_MARGIN;
		CGFloat numbersY = VERTICAL_MARGIN + ROW_HEIGHT + ROW_OFFSET;
		CGRect numbersFrame = CGRectMake(numbersX, numbersY, [numbersView bounds].size.width, [numbersView bounds].size.height);
		[numbersView setFrame:numbersFrame];
		[[self contentView] addSubview:numbersView];
	}
}

@end
