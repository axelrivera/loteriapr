//
//  LotteryViewController.m
//  LotteryPR
//
//  Created by Axel Rivera on 12/23/10.
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryViewController.h"
#import "LinkViewController.h"
#import "Lottery.h"
#import "LotteryTwo.h"
#import "LotteryThree.h"
#import "LotteryFour.h"
#import "LotterySix.h"
#import "FileHelpers.h"

#define BALL_SIZE 35.0
#define BALL_OFFSET 5.0

@implementation LotteryViewController

@synthesize nibLoadedCell;
@synthesize lotteryNumbers;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.navigationBar.topItem.title = @"Números Ganadores";
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Ganadores";
	self.navigationItem.backBarButtonItem = barButtonItem;
	[barButtonItem release];
	
	[self showRefreshButtonItem];
	[self loadNumbers:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
	nibLoadedCell = nil;
	lotteryNumbers = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[nibLoadedCell release];
	[lotteryNumbers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)loadNumbers:(id)sender {
	if (lotteryNumbers == nil) {
		self.lotteryNumbers = [NSMutableDictionary dictionaryWithCapacity:5];
	}
	
	[self showLoadingButtonItem];
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:@"http://loteriaelectronicapr.com/rss/rss.aspx"];
	
	// Create a request object with that URL								  
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringCacheData 
										 timeoutInterval:30]; 
	
    // Clear out the existing connection if there is one 
    if (connectionInProgress) { 
        [connectionInProgress cancel]; 
        [connectionInProgress release]; 
    } 
	
	// Create and initiate the connection
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request 
                                                           delegate:self 
                                                   startImmediately:YES]; 
	
	// Instantiate the object to hold all incoming data
    [xmlData release]; 
    xmlData = [[NSMutableData alloc] init]; 
}

#pragma mark -
#pragma mark Class Methods

- (UILabel *)numberLabel:(NSNumber *)num withPoint:(CGPoint)pt {
	CGRect labelRect = CGRectMake(pt.x, pt.y, 35.0, 35.0);
	UILabel *label = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
	label.textAlignment =  UITextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
	label.text = [NSString stringWithFormat:@"%d", [num intValue]];
	return label;
}

- (void)addNumberLabelsToView:(UIView *)numView withNumbers:(NSArray *)numArray {
	int positionY = 0.0;
	int positionX = 0.0;
	for (int i = 0; i < [numArray count]; i++) {
		if (i > 0) {
			positionX = positionX + BALL_OFFSET + BALL_SIZE;
		}
		[numView addSubview:[self numberLabel:[numArray objectAtIndex:i] withPoint:CGPointMake(positionX, positionY)]];
	}
}

- (void)showLoadingButtonItem {
	// initing the loading view
	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:frame];
	[loading startAnimating];
	[loading sizeToFit];
	loading.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
								UIViewAutoresizingFlexibleRightMargin |
								UIViewAutoresizingFlexibleTopMargin |
								UIViewAutoresizingFlexibleBottomMargin);
	
	// initing the bar button
	UIBarButtonItem *loadingView = [[[UIBarButtonItem alloc] initWithCustomView:loading] autorelease];
	
	[loading release];
	loadingView.target = self;
	self.navigationItem.rightBarButtonItem = loadingView;	
}

- (void)showRefreshButtonItem {
	UIBarButtonItem *reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																					  target:self
																					  action:@selector(loadNumbers:)];
	
	self.navigationItem.rightBarButtonItem = reloadButtonItem;
	[reloadButtonItem release];
}

- (NSString *)lotteryFilePath {
	return pathInDocumentDirectory(@"Lottery.data");
}

#pragma mark -
#pragma mark NSXMLParser Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { 
    [xmlData appendData:data]; 
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData]; 
    [parser setDelegate:self]; 
    [parser parse]; 
    [parser release];
	
	if ([lotteryNumbers objectForKey:LotoKey] == nil) {
		LotterySix *loto = [[LotterySix alloc] initWithName:LotoTitle];
		[lotteryNumbers setObject:loto forKey:LotoKey];
		[loto release];
		loto = nil;
	}
	
	if ([lotteryNumbers objectForKey:RevanchaKey] == nil) {
		LotterySix *revancha = [[LotterySix alloc] initWithName:RevanchaTitle];
		[lotteryNumbers setObject:revancha forKey:RevanchaKey];
		[revancha release];
		revancha = nil;
	}
	
	if ([lotteryNumbers objectForKey:PegaCuatroKey] == nil) {
		LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:PegaCuatroTitle];
		[lotteryNumbers setObject:pegaCuatro forKey:PegaCuatroKey];
		[pegaCuatro release];
		pegaCuatro = nil;
	}
	
	if ([lotteryNumbers objectForKey:PegaTresKey] == nil) {
		LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:PegaTresTitle];
		[lotteryNumbers setObject:pegaTres forKey:PegaTresKey];
		[pegaTres release];
		pegaTres = nil;
	}
	
	if ([lotteryNumbers objectForKey:PegaDosKey] == nil) {
		LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:PegaDosTitle];
		[lotteryNumbers setObject:pegaDos forKey:PegaDosKey];
		[pegaDos release];
		pegaDos = nil;
	}
		
	[NSKeyedArchiver archiveRootObject:lotteryNumbers toFile:[self lotteryFilePath]];
	[[self tableView] reloadData];
	[self showRefreshButtonItem];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict { 
	if([elementName isEqual:xmlItem]) {
		waitingForItemTitle = YES;
		waitingForItemDate = YES;
	}
	if (tmpString != nil) {
		[tmpString release];
		tmpString = nil;
	}
	tmpString = [[NSMutableString alloc] initWithCapacity:1];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    [tmpString appendString:string];
} 

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqual:xmlTitleItem] && waitingForItemTitle) { 
		titleString = [NSMutableString stringWithString:tmpString];
    }
    if ([elementName isEqual:xmlDateItem] && waitingForItemDate) { 
		dateString = [NSMutableString stringWithString:tmpString];
    }
	
	[tmpString release];
	tmpString = nil;
	
	if([elementName isEqual:xmlItem]) {
		NSArray *titleAndNumber = [titleString componentsSeparatedByString:xmlTitleDivider];
		
		if ([LotoTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *loto = [[LotterySix alloc] initWithName:LotoTitle
														numbers:[titleAndNumber objectAtIndex:1]
														   date:dateString];
			[lotteryNumbers setObject:loto forKey:LotoKey];
			[loto release];
			loto = nil;
		}
		
		if ([RevanchaTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *revancha = [[LotterySix alloc] initWithName:RevanchaTitle
															numbers:[titleAndNumber objectAtIndex:1]
															   date:dateString];
			[lotteryNumbers setObject:revancha forKey:RevanchaKey];
			[revancha release];
			revancha = nil;
		}
		
		if ([PegaCuatroTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:PegaCuatroTitle
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaCuatro forKey:PegaCuatroKey];
			[pegaCuatro release];
			pegaCuatro = nil;
		}
		
		if ([PegaTresTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:PegaTresTitle
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaTres forKey:PegaTresKey];
			[pegaTres release];
			pegaTres = nil;
		}
		
		if ([PegaDosTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:PegaDosTitle
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaDos forKey:PegaDosKey];
			[pegaDos release];
			pegaDos = nil;
		}
		
		waitingForItemTitle = NO;
		waitingForItemDate = NO;
	}	
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { 
    [connectionInProgress release]; 
    connectionInProgress = nil; 
    [xmlData release]; 
    xmlData = nil; 
    NSString *errorString = [NSString stringWithFormat:@"No Internet Connection", 
                             [error localizedDescription]]; 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
													message:errorString
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	[self showRefreshButtonItem];
	
	self.lotteryNumbers = [NSKeyedUnarchiver unarchiveObjectWithFile:[self lotteryFilePath]];
	[[self tableView] reloadData];
}    

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (lotteryNumbers == nil) {
		return 0;
	}
    return [lotteryNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LotteryTableCell" owner:self options:NULL];
		cell = nibLoadedCell;
	} else {
		UIView *viewToClean = nil;
		viewToClean = [cell.contentView viewWithTag:2];
		for (UIView *localView in viewToClean.subviews) {
			[localView removeFromSuperview];
		}
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_US"];
	
	[formatter setLocale: usLocale];
	[usLocale release];
	
	//[formatter setTimeZone:[NSTimeZone systemTimeZone]];
	// The original date string was in GMT
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	[formatter setDateFormat:@"EEE, dd MMM yyyy"];
	
	UIImageView *logoView = (UIImageView *)[cell viewWithTag:1];
	UIImageView *numbersView = (UIImageView *)[cell viewWithTag:2];
	UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
	
	if (indexPath.row == 0) {
		[logoView setImage:[UIImage imageNamed:@"loto.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_six.png"]];
		
		LotterySix *loto = [lotteryNumbers objectForKey:LotoKey];
		dateLabel.text = [formatter stringFromDate:loto.drawDate];
				
		[self addNumberLabelsToView:numbersView withNumbers:[loto winningNumbers]];
	} else if (indexPath.row == 1) {
		[logoView setImage:[UIImage imageNamed:@"revancha.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_six.png"]];
		
		LotterySix *revancha = [lotteryNumbers objectForKey:RevanchaKey];
		dateLabel.text = [formatter stringFromDate:revancha.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[revancha winningNumbers]];
	} else if (indexPath.row == 2) {
		[logoView setImage:[UIImage imageNamed:@"pegacuatro.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_four.png"]];
		
		LotteryFour *pegaCuatro = [lotteryNumbers objectForKey:PegaCuatroKey];
		dateLabel.text = [formatter stringFromDate:pegaCuatro.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaCuatro winningNumbers]];
	} else if (indexPath.row == 3) {
		[logoView setImage:[UIImage imageNamed:@"pegatres.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_three.png"]];
		
		LotteryThree *pegaTres = [lotteryNumbers objectForKey:PegaTresKey];
		dateLabel.text = [formatter stringFromDate:pegaTres.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaTres winningNumbers]];
	} else if (indexPath.row == 4) {
		[logoView setImage:[UIImage imageNamed:@"pegados.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_two.png"]];
		
		LotteryTwo *pegaDos = [lotteryNumbers objectForKey:PegaDosKey];
		dateLabel.text = [formatter stringFromDate:pegaDos.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaDos winningNumbers]];
	}
	
	[formatter release];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (linkViewController == nil) {
		linkViewController = [[LinkViewController alloc] init];
	}
	
	if (indexPath.row == 0) {
		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:LotoKey]];
	} else if (indexPath.row == 1) {
		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:RevanchaKey]];
	} else if (indexPath.row == 2) {
		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaCuatroKey]];
	} else if (indexPath.row == 3) {
		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaTresKey]];
	} else if (indexPath.row == 4) {
		[linkViewController setActiveLottery:[lotteryNumbers objectForKey:PegaDosKey]];
	}

	linkViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:linkViewController 
										   animated:YES];
}

@end
