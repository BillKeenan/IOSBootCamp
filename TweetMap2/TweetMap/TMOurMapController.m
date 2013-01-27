//
//  TMOurMapController.m
//  TweetMap
//
//  Created by Michael Reyder on 13-01-27.
//  Copyright (c) 2013 Michael Reyder. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define twitterSearchURL [NSURL URLWithString: @"http://dl.dropbox.com/u/10772655/test.json" ]
#define twitterSearchURL [NSURL URLWithString: @"http://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=mralexgray&count=1" ]

#import "TMOurMapController.h"
#import "Pin.h"

@interface TMOurMapController ()

@end

@implementation TMOurMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0., 0., 320., 480.)];
    mapView.delegate = self;
    self.view = mapView;
    
    CLLocationCoordinate2D pinLocation;
    pinLocation.latitude = 43.649553;
    pinLocation.longitude = -79.389181;
    
    MKCoordinateRegion region;
    region.center=pinLocation;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    span.latitudeDelta=2.0;
    span.longitudeDelta=2.0;
    region.span=span;
    
    [(MKMapView*)self.view setRegion:region animated:TRUE];

    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        twitterSearchURL];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:false];
    });
}

- (void)fetchedData:(NSData *)responseData { //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    NSDictionary* latestTweet = json[0]; //2
    NSArray *geo = latestTweet[@"geo"][@"coordinates"];
    double lat = [geo[0] doubleValue];
    double lon = [geo[1] doubleValue];
    NSString *tweet = latestTweet[@"text"];
    NSString *user = latestTweet[@"user"][@"name"];
    NSLog(@"tweet: %f,%f", lat, lon); //3
  
    CLLocationCoordinate2D pinLocation;
	pinLocation.latitude = lat;
	pinLocation.longitude = lon;

	MapPin *pin = [[MapPin alloc] initWithCoordinate:pinLocation withTitle:tweet withSubTitle:user];
	[(MKMapView*)self.view addAnnotation:pin];

    
    MKCoordinateRegion region;
    region.center=pinLocation;
    
    [mapView setRegion:region];
    

}



@end
