//
//  FileSharingViewController.m
//  FileSharing
//
//  Created by James Eberhardt on 10-09-16.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FileSharingViewController.h"

@implementation FileSharingViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // find the users documents directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];   
	
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDir error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    }
	
	//Display the image.
    if ([files count] > 0){
        NSLog(@"Adding image");
        NSString* path = [docsDir stringByAppendingPathComponent: 
                          [NSString stringWithString: [files objectAtIndex:0]] ];
        NSLog (@"Path: %@", path);
		UIImage *importedImage = [UIImage imageWithContentsOfFile:path];
        NSLog(@"imported Image: %@", importedImage);
		UIImageView *importedImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		importedImageView.image = importedImage;
		[self.view addSubview:importedImageView];
	}
	
}

@end