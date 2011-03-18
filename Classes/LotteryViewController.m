//
//  LotteryViewController.m
//  LotteryPR
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import "LotteryViewController.h"
#import "LinkViewController.h"
#import "NumbersViewController.h"
#import "AboutViewController.h"
#import "LotteryData.h"
#import "Lottery.h"
#import "LotteryTwo.h"
#import "LotteryThree.h"
#import "LotteryFour.h"
#import "LotterySix.h"
#import "FileHelpers.h"
#import "LotteryBallView.h"
#import "LotteryCell.h"
#import "Reachability.h"

BOOL validRSS;

@implementation LotteryViewController

@synthesize lotteryNumbers;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.navigationBar.topItem.title = @"Números Ganadores";
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Ganadores";
	self.navigationItem.backBarButtonItem = barButtonItem;
	[barButtonItem release];
	
	[self showInfoButtonItem];
	[self showRefreshButtonItem];
	[self setLotteryNumbers:[NSMutableDictionary dictionaryWithDictionary:[[LotteryData sharedLotteryData] latestNumbers]]];
	[self loadNumbers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
	lotteryNumbers = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[lotteryNumbers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Action Methods

- (void)loadNumbers {
	validRSS = NO;
	BOOL networkAvailable = YES;
	Reachability *reach = [[Reachability reachabilityForInternetConnection] retain];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
		networkAvailable = NO;        
    }
	[reach release];
	if (!networkAvailable) {
		NSString *errorString = [NSString stringWithFormat:@"No Internet Connection Available"]; 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
														message:errorString
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];	
		[alert release];

		return;
	}
	
	[self showLoadingButtonItem];
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:DefaultRss];
	
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

- (void)loadAbout {
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
																					 bundle:nil];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
#pragma mark Class Methods

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
																					  action:@selector(loadNumbers)];
	
	self.navigationItem.rightBarButtonItem = reloadButtonItem;
	[reloadButtonItem release];
}

- (void)showInfoButtonItem {
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"]
																		style:UIBarButtonItemStyleBordered
																	   target:self
																	   action:@selector(loadAbout)];
	
	self.navigationItem.leftBarButtonItem = infoButtonItem;
	[infoButtonItem release];
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
	
	[[LotteryData sharedLotteryData] updateLatestNumbersWithDictionary:lotteryNumbers];
	[[self tableView] reloadData];
	[self showRefreshButtonItem];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"rss"]) {
		validRSS = YES;
	}
	
	if (!validRSS) {
		[parser abortParsing];
	}
	
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
    NSString *errorString = [NSString stringWithFormat:@"No Internet Connection Available", 
                             [error localizedDescription]]; 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
													message:errorString
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	[self showRefreshButtonItem];
	[[self tableView] reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString *errorString = [NSString stringWithFormat:@"La información no esta disponible en la página web de la Loteria Electrónica"]; 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:errorString
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (lotteryNumbers == nil) {
		return 0;
	}
    return [lotteryNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LotteryCell *cell = (LotteryCell *)[tableView dequeueReusableCellWithIdentifier:@"LotteryCell"];
	if (cell == nil) {
		cell = [[[LotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LotteryCell"] autorelease];
	}
	
	if (indexPath.row == 0) {
		LotterySix *loto = [lotteryNumbers objectForKey:LotoKey];
		[cell setLoto:loto];
	} else if (indexPath.row == 1) {
		LotterySix *revancha = [lotteryNumbers objectForKey:RevanchaKey];
		[cell setRevancha:revancha];
	} else if (indexPath.row == 2) {
		LotteryFour *pegaCuatro = [lotteryNumbers objectForKey:PegaCuatroKey];
		[cell setPegaCuatro:pegaCuatro];
	} else if (indexPath.row == 3) {
		LotteryThree *pegaTres = [lotteryNumbers objectForKey:PegaTresKey];
		[cell setPegaTres:pegaTres];
	} else if (indexPath.row == 4) {
		LotteryTwo *pegaDos = [lotteryNumbers objectForKey:PegaDosKey];
		[cell setPegaDos:pegaDos];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
