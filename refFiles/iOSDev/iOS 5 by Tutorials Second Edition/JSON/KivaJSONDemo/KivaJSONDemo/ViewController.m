//
//  ViewController.m
//  KivaJSONDemo
//
//  Created by Marin Todorov on 05/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#define kLatestKivaLoansURL [NSURL URLWithString: @"http://api.kivaws.org/v1/loans/search.json?status=fundraising" ] //2

#import "ViewController.h" 

@interface ViewController () {
    IBOutlet UILabel* humanReadble;
    IBOutlet UILabel* jsonSummary;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData { //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    NSArray* latestLoans = json[@"loans"]; //2
    NSLog(@"loans: %@", latestLoans); //3
    
    // 1) Get the latest loan
    NSDictionary* loan = latestLoans[0];
    // 2) Get the funded amount and loan amount
    NSNumber* fundedAmount = loan[@"funded_amount"];
    NSNumber* loanAmount = loan[@"loan_amount"];
    
    float outstandingAmount = [loanAmount floatValue] - [fundedAmount floatValue];
    
    // 3) Set the label appropriately
    humanReadble.text = [NSString stringWithFormat:@"Latest loan: %@ from %@ needs another $%.2f to pursue their entrepreneural dream",
                         loan[@"name"],
                         loan[@"location"][@"country"],
                         outstandingAmount
                         ];
    
    NSDictionary* info = @{@"who": loan[@"name"],
                          @"where": loan[@"location"][@"country"],
                          @"what": [NSNumber numberWithFloat: outstandingAmount]};
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    
    jsonSummary.text = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
}

@end