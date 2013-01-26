//
//  ViewController.m
//  KivaJSONDemo
//
//  Created by James Eberhardt on 2012-10-31.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dispatch_async(kBgQueue,^{
        NSData *data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData :(NSData *)responseData{
    NSError *error;
    NSDictionary *data =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *latestLoans = [data	 objectForKey:@"loans"];
    NSLog(@"loans: %@",latestLoans);
    
    NSLog(@"number of loans: %i",latestLoans.count);

    // 1) Get the latest loan
    NSDictionary* loan = [latestLoans objectAtIndex:0];
    // 2) Get the funded amount and loan amount
    NSNumber* fundedAmount = [loan objectForKey:@"funded_amount"];
    NSNumber* loanAmount = [loan objectForKey:@"loan_amount"];
    float outstandingAmount = [loanAmount floatValue] - [fundedAmount
                                                         floatValue];
    // 3) Set the label appropriately
    humanReadble.text = [NSString stringWithFormat:@"Latest loan: %@ from %@ needs another $%.2f to pursue their entrepreneural dream", [loan
                                      objectForKey:@"name"], [(NSDictionary*)[loan objectForKey:@"location"]
                                                              objectForKey:@"country"], outstandingAmount];
    
    
    //build an info object and convert to json
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [loan objectForKey:@"name"], @"who",
                          [(NSDictionary*)[loan objectForKey:@"location"] objectForKey:@"country"],
                          @"where",
                          [NSNumber numberWithFloat: outstandingAmount], @"what",
                          nil];
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    jsonSummary.text = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
