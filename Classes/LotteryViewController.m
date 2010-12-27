//
//  LotteryViewController.m
//  LotteryPR
//
//  Created by arn on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LotteryViewController.h"
#import "Lottery.h"
#import "LotteryTwo.h"
#import "LotteryThree.h"
#import "LotteryFour.h"
#import "LotterySix.h"

#define BALL_SIZE 35.0
#define BALL_OFFSET 5.0

@implementation LotteryViewController

@synthesize nibLoadedCell;

- (void)viewDidLoad {
	[super viewDidLoad];
	if (lotteryNumbers == nil) {
		lotteryNumbers = [[NSMutableDictionary alloc] init];
	}
	self.title = @"Ganadores";
	self.navigationController.navigationBar.topItem.title = @"Números Ganadores";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self loadNumbers];
}

- (void)loadNumbers {
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:@"http://loteriaelectronicapr.com/"
				  @"rss/rss.aspx"];
	
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { 
    [xmlData appendData:data]; 
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData]; 
    [parser setDelegate:self]; 
    [parser parse]; 
    [parser release];
	
	if ([lotteryNumbers objectForKey:@"lotoKey"] == nil) {
		LotterySix *loto = [[LotterySix alloc] initWithName:LotoTitle];
		[lotteryNumbers setObject:loto forKey:@"lotoKey"];
		[loto release];
		loto = nil;
	}
	
	if ([lotteryNumbers objectForKey:@"revanchaKey"] == nil) {
		LotterySix *revancha = [[LotterySix alloc] initWithName:RevanchaTitle];
		[lotteryNumbers setObject:revancha forKey:@"revanchaKey"];
		[revancha release];
		revancha = nil;
	}
	
	if ([lotteryNumbers objectForKey:@"pegaCuatroKey"] == nil) {
		LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:PegaCuatroTitle];
		[lotteryNumbers setObject:pegaCuatro forKey:@"pegaCuatroKey"];
		[pegaCuatro release];
		pegaCuatro = nil;
	}
	
	if ([lotteryNumbers objectForKey:@"pegaTresKey"] == nil) {
		LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:PegaTresTitle];
		[lotteryNumbers setObject:pegaTres forKey:@"pegaTresKey"];
		[pegaTres release];
		pegaTres = nil;
	}
	
	if ([lotteryNumbers objectForKey:@"pegaCuatroKey"] == nil) {
		LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:PegaDosTitle];
		[lotteryNumbers setObject:pegaDos forKey:@"pegaDosKey"];
		[pegaDos release];
		pegaDos = nil;
	}
		
	[[self tableView] reloadData];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict { 
	if([elementName isEqual:@"item"]) {
		waitingForItemTitle = YES;
		waitingForItemDate = YES;
	}
	tmpString = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    [tmpString appendString:string];
} 

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqual:@"title"] && waitingForItemTitle) { 
		titleString = [NSString stringWithString:tmpString];
    }
    if ([elementName isEqual:@"pubDate"] && waitingForItemDate) { 
		dateString = [NSString stringWithString:tmpString];
    }
		
	[tmpString release];
	tmpString = nil;
	
	if([elementName isEqual:@"item"]) {
		NSArray *titleAndNumber = [titleString componentsSeparatedByString:@" - "];
		
		if ([LotoTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *loto = [[LotterySix alloc] initWithName:[titleAndNumber objectAtIndex:0]
														numbers:[titleAndNumber objectAtIndex:1]
														   date:dateString];
			[lotteryNumbers setObject:loto forKey:@"lotoKey"];
			[loto release];
			loto = nil;
		}
		
		if ([RevanchaTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotterySix *revancha = [[LotterySix alloc] initWithName:[titleAndNumber objectAtIndex:0]
															numbers:[titleAndNumber objectAtIndex:1]
															   date:dateString];
			[lotteryNumbers setObject:revancha forKey:@"revanchaKey"];
			[revancha release];
			revancha = nil;
		}
		
		if ([PegaCuatroTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryFour *pegaCuatro = [[LotteryFour alloc] initWithName:[titleAndNumber objectAtIndex:0]
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaCuatro forKey:@"pegaCuatroKey"];
			[pegaCuatro release];
			pegaCuatro = nil;
		}
		
		if ([PegaTresTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryThree *pegaTres = [[LotteryThree alloc] initWithName:[titleAndNumber objectAtIndex:0]
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaTres forKey:@"pegaTresKey"];
			[pegaTres release];
			pegaTres = nil;
		}
		
		if ([PegaDosTitle isEqualToString:[titleAndNumber objectAtIndex:0]]) {
			LotteryTwo *pegaDos = [[LotteryTwo alloc] initWithName:[titleAndNumber objectAtIndex:0]
																numbers:[titleAndNumber objectAtIndex:1]
																   date:dateString];
			[lotteryNumbers setObject:pegaDos forKey:@"pegaDosKey"];
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
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", 
                             [error localizedDescription]]; 
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString 
                                                             delegate:nil 
                                                    cancelButtonTitle:@"OK" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:nil]; 
    [actionSheet showInView:[[self view] window]];
    [actionSheet autorelease]; 
}    

#pragma mark Table view methods

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
	
	[formatter setDateFormat:@"EEE, dd MMM yyyy"];
	
	UIImageView *logoView = (UIImageView *)[cell viewWithTag:1];
	UIImageView *numbersView = (UIImageView *)[cell viewWithTag:2];
	UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
	
	if (indexPath.row == 0) {
		[logoView setImage:[UIImage imageNamed:@"loto.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_six.png"]];
		
		LotterySix *loto = [lotteryNumbers objectForKey:@"lotoKey"];
		dateLabel.text = [formatter stringFromDate:loto.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[loto winningNumbers]];
	} else if (indexPath.row == 1) {
		[logoView setImage:[UIImage imageNamed:@"revancha.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_six.png"]];
		
		LotterySix *revancha = [lotteryNumbers objectForKey:@"revanchaKey"];
		dateLabel.text = [formatter stringFromDate:revancha.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[revancha winningNumbers]];
	} else if (indexPath.row == 2) {
		[logoView setImage:[UIImage imageNamed:@"pegacuatro.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_four.png"]];
		
		LotteryFour *pegaCuatro = [lotteryNumbers objectForKey:@"pegaCuatroKey"];
		dateLabel.text = [formatter stringFromDate:pegaCuatro.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaCuatro winningNumbers]];
	} else if (indexPath.row == 3) {
		[logoView setImage:[UIImage imageNamed:@"pegatres.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_three.png"]];
		
		LotteryThree *pegaTres = [lotteryNumbers objectForKey:@"pegaTresKey"];
		dateLabel.text = [formatter stringFromDate:pegaTres.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaTres winningNumbers]];
	} else if (indexPath.row == 4) {
		[logoView setImage:[UIImage imageNamed:@"pegados.png"]];
		[numbersView setImage:[UIImage imageNamed:@"circle_two.png"]];
		
		LotteryTwo *pegaDos = [lotteryNumbers objectForKey:@"pegaDosKey"];
		dateLabel.text = [formatter stringFromDate:pegaDos.drawDate];
		
		[self addNumberLabelsToView:numbersView withNumbers:[pegaDos winningNumbers]];
	}
	
	[formatter release];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0;
}

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

- (void)viewDidUnload {
	[nibLoadedCell release];
	nibLoadedCell = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[nibLoadedCell release];
    [super dealloc];
}

@end
