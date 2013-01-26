//
//  RootViewController.m
//  DownloadedImageExample
//
//  Created by James Eberhardt on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize receivedData=_receivedData;
@synthesize expectedContentLength=_expectedContentLength;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] init];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // check to see if the file has already been downloaded.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.jpg"];
            
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == TRUE) {
        // load the existing image
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        UIImage *img = [[UIImage alloc] initWithData:data];	
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 480)];
        
        imgView.image = img;
        [self.view addSubview:imgView];
    } else {
        // Let's add a progress bar and make it hidden for later use.
        UIProgressView *myProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        myProgressView.center = CGPointMake(100., 100.);
        myProgressView.hidden = TRUE;
        myProgressView.tag = 100;
        [self.view addSubview:myProgressView];
        
        BOOL easy = TRUE;
        BOOL small = TRUE;
        
        //    NSLog(@"Should be getting image.");
        NSString *path = (small) ? @"http://www.a-gc.com/images/2012/09/animals-monkeys-HD-Wallpapers.jpg" :
        @"http://eberhardt.ca/queen_natasha.png";
        NSURL *url = [NSURL URLWithString:path];
        
        if (easy){
        // This is the easy way of getting the image.
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];	
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 480)];

            imgView.image = img;
            [self.view addSubview:imgView];
        } else {
        // This is the hard way of downloading an image.
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (conn) {
                // Create the NSMutableData that will hold the received data
                // receivedData is declared as a method instance elsewhere
                if (self.receivedData == NULL){
                    self.receivedData=[NSMutableData data];
                }
            } else {
                // inform the user that the download could not be made
                NSLog(@"The connection could not be made.");
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    self.expectedContentLength = [NSNumber numberWithLong: [response expectedContentLength]];
	NSLog (@"Got a response: %@", self.expectedContentLength);
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [self.receivedData appendData:data];
    
    NSNumber *curLength = [NSNumber numberWithLong:[self.receivedData length]];
    float percentDownloaded = [curLength floatValue] / [self.expectedContentLength floatValue];
    NSLog(@"Percent downloaded: %f", percentDownloaded);
    
    UIProgressView *myProgressView = (UIProgressView*)[self.view viewWithTag:100];
    myProgressView.hidden = FALSE;
    myProgressView.progress = percentDownloaded;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	UIImage *img = [[UIImage alloc] initWithData:self.receivedData];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 480)];
	imgView.image = img;
    [self.view addSubview:imgView];
    
    // Save the image to a folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.jpg"];
    
    [self.receivedData writeToFile:filePath atomically:YES];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Do something here to handle the error: %@", error);
}

@end
