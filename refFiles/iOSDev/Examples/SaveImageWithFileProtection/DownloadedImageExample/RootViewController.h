//
//  RootViewController.h
//  DownloadedImageExample
//
//  Created by James Eberhardt on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <NSURLConnectionDelegate>{
    NSMutableData *_receivedData;
    NSNumber *_expectedContentLength;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSNumber *expectedContentLength;

@end
