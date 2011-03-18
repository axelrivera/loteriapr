//
//  VerifyCell.m
//  LotteryPR
//
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "VerifyCell.h"
#import "LotteryData.h"
#import "Lottery.h"
#import "LotterySix.h"
#import "LotteryFour.h"
#import "LotteryThree.h"
#import "LotteryTwo.h"
#import "LotteryBallView.h"
#import "LotteryBall.h"

#define VERTICAL_MARGIN 10
#define HORIZONTAL_MARGIN 10
#define COLUMN_OFFSET 10
#define ROW_HEIGHT 35
#define THIRD_ROW_HEIGHT 16
#define ROW_OFFSET 5
#define LOGO_WIDTH 100

@interface VerifyCell (Private)

- (void)setLongDateFormat;
- (void)setShortDateFormat;

@end;

@implementation VerifyCell

@synthesize numbersView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		lotteryData = [LotteryData sharedLotteryData];
		self.opaque = YES;
		// Background Color is Black and Transparent
		self.backgroundColor = [UIColor whiteColor];
		self.selectionStyle = UITableViewCellEditingStyleNone;
		
		// Date Formatter Settings
		dateFormatter = [[NSDateFormatter alloc] init];
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_US"];
		
		[dateFormatter setLocale: usLocale];
		[usLocale release];
		
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[dateLabel setBackgroundColor:[UIColor clearColor]];
		[dateLabel setTextColor:[UIColor darkGrayColor]];
		[dateLabel setTextAlignment:UITextAlignmentRight];
		[[self contentView] addSubview:dateLabel];
		
		updateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[updateLabel setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
		[updateLabel setBackgroundColor:[UIColor clearColor]];
		[updateLabel setTextColor:[UIColor lightGrayColor]];
		[updateLabel setTextAlignment:UITextAlignmentLeft];
		[[self contentView] addSubview:updateLabel];
		
		logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:logoView];
		
        // Tell the imageview to resize its image to fit inside its frame
        [logoView setContentMode:UIViewContentModeLeft];
		
		[self setNumbersView:[[LotteryBallView alloc] initWithType:LotteryTypeNone ballColor:LotteryBallColorWhite]];
		[[self contentView] addSubview:numbersView];
    }
    return self;
}

- (void)layoutSubviews {
	// We always call this, the table view cell needs to do its own work first
	[super layoutSubviews];
	
	CGRect bounds = [[self contentView] bounds];
	
	CGFloat numbersY = VERTICAL_MARGIN + ROW_HEIGHT + ROW_OFFSET;
	
	CGRect logoFrame = CGRectMake(HORIZONTAL_MARGIN, VERTICAL_MARGIN, LOGO_WIDTH, ROW_HEIGHT);
	[logoView setFrame:logoFrame];
	
	CGFloat dateOffset = (HORIZONTAL_MARGIN * 2) + LOGO_WIDTH + COLUMN_OFFSET;
	CGFloat dateWidth = bounds.size.width - dateOffset;
	CGFloat dateHeight = ROW_HEIGHT;
	CGFloat dateX = HORIZONTAL_MARGIN + LOGO_WIDTH + COLUMN_OFFSET;
	CGFloat dateY = VERTICAL_MARGIN;
	
	CGRect dateFrame = CGRectMake(dateX, dateY, dateWidth, dateHeight);
	[dateLabel setFrame:dateFrame];
		
	CGFloat updateX = HORIZONTAL_MARGIN;
	CGFloat updateY = numbersY + ROW_HEIGHT + ROW_OFFSET;
	CGFloat updateWidth = bounds.size.width - (HORIZONTAL_MARGIN * 2);
	CGFloat updateHeight = THIRD_ROW_HEIGHT;
	CGRect updateFrame = CGRectMake(updateX, updateY, updateWidth, updateHeight);
	[updateLabel setFrame:updateFrame];
}

- (void)dealloc {
    [super dealloc];
	[dateFormatter release];
	[numbersView release];
	[logoView release];
	[dateLabel release];
	[updateLabel release];
}

#pragma mark -
#pragma mark Custom Instance Methods

- (void)setLoto {
	[logoView setImage:[UIImage imageNamed:@"loto.png"]];
	[numbersView setLotteryType:LotteryTypeSix];
}

- (void)setRevancha {
	[logoView setImage:[UIImage imageNamed:@"revancha.png"]];
	[numbersView setLotteryType:LotteryTypeSix];
}

- (void)setPegaCuatro {
	[logoView setImage:[UIImage imageNamed:@"pegacuatro.png"]];
	[numbersView setLotteryType:LotteryTypeFour];
}

- (void)setPegaTres {
	[logoView setImage:[UIImage imageNamed:@"pegatres.png"]];
	[numbersView setLotteryType:LotteryTypeThree];
}

- (void)setPegaDos {
	[logoView setImage:[UIImage imageNamed:@"pegados.png"]];
	[numbersView setLotteryType:LotteryTypeTwo];
}

- (void)setDateLabel:(NSDate *)date {
	[self setShortDateFormat];
	[dateLabel setText:[NSString stringWithFormat:@"Sorteo: %@", [dateFormatter stringFromDate:date]]];
}

- (void)setUpdateLabel:(NSDate *)date {
	[self setLongDateFormat];
	[updateLabel setText:[NSString stringWithFormat:@"Actualizado: %@", [dateFormatter stringFromDate:date]]];
}

- (void)setShortDateFormat {
	//[formatter setTimeZone:[NSTimeZone systemTimeZone]];
	// The original date string was in GMT
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	[dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
}

- (void)setLongDateFormat {
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateFormat:@"dd MMM yyyy, hh:mm aaa"];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

@end


