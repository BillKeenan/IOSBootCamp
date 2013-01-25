//
//  MapKitExampleViewController.m
//  MapKitExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapKitExampleViewController.h"
#import "MapPin.h"

@implementation MapKitExampleViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
	mapView.showsUserLocation = TRUE;
    //mapView.userTrackingMode = MKUserTrackingModeFollow;
	mapView.delegate = self;
	
	self.view = mapView;

	CLLocationCoordinate2D pinLocation;
	pinLocation.latitude = 43.649553;
	pinLocation.longitude = -79.389181;
	[self addPin:pinLocation];
	
	MKCoordinateRegion region;
	region.center=pinLocation;
	
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta=2.0;
	span.longitudeDelta=2.0;
	region.span=span;
	
	[(MKMapView*)self.view setRegion:region animated:TRUE];
    
}

-(void)addPin:(CLLocationCoordinate2D)pinLocation{
	MapPin *pin = [[MapPin alloc] initWithCoordinate:pinLocation withTitle:@"The pin title" withSubTitle:@"Whatever"];
	[(MKMapView*)self.view addAnnotation:pin];
	[pin release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	
    MKPinAnnotationView *annotationView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"locationAnnotationView"] autorelease];
	
    if ([annotation isMemberOfClass:[MKUserLocation class]]){
		[annotationView setPinColor:MKPinAnnotationColorRed];
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		annotationView.userInteractionEnabled=TRUE;
		annotationView.animatesDrop=TRUE;
		annotationView.canShowCallout = TRUE;
		annotationView.enabled = TRUE;
//		return nil;
	} else {
		[annotationView setPinColor:MKPinAnnotationColorGreen];
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		annotationView.userInteractionEnabled=TRUE;
		annotationView.animatesDrop=TRUE;
		annotationView.canShowCallout = TRUE;
		annotationView.enabled = TRUE;
        annotationView.tag = 1;
	}

	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"calloutAccessoryControlTapped: %@", view);
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
