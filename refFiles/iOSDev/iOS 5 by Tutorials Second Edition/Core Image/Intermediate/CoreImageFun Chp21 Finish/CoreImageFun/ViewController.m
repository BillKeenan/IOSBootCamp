//
//  ViewController.m
//  CoreImageFun
//
//  Created by Jake Gundersen on 10/18/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Resize.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController {
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
    UIImageOrientation orientation;
    BOOL maskMode;
    
    CIImage *maskImage;
    
    CGContextRef cgcontext;
    
    NSArray * filtersArray;
    NSUInteger filterIndx;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];

    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];

    // 1
    context = [CIContext contextWithOptions:nil];

    filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];

    // 2
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];

    // 3
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;

    // 4
    CGImageRelease(cgimg);
    maskMode = NO;
//    [self logAllFilters];
    
    maskImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"sampleMaskPng.png"].CGImage];
    
    [self loadFiltersArray];
}

-(void)loadFiltersArray {
    CIFilter *affineTransform = [CIFilter filterWithName: @"CIAffineTransform" keysAndValues:kCIInputImageKey, beginImage, @"inputTransform", [NSValue valueWithCGAffineTransform: CGAffineTransformMake(1.0, 0.4, 0.5, 1.0, 0.0, 0.0)], nil];
    
    CIFilter *straightenFilter = [CIFilter filterWithName: @"CIStraightenFilter" keysAndValues:kCIInputImageKey, beginImage, @"inputAngle", @2.0, nil];
    
    CIFilter *vibrance = [CIFilter filterWithName:@"CIVibrance" keysAndValues:kCIInputImageKey, beginImage, @"inputAmount", @-0.85, nil];
    
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", @-0.5, @"inputContrast", @3.0, @"inputSaturation", @1.5, nil];
    
    CIFilter *colorInvert = [CIFilter filterWithName:@"CIColorInvert" keysAndValues:kCIInputImageKey, beginImage, nil];
    
    CIFilter *highlightsAndShadows = [CIFilter filterWithName: @"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, beginImage, @"inputShadowAmount", @1.5, @"inputHighlightAmount", @0.2, nil];
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, beginImage, nil];
    
    CIFilter *pixellate = [CIFilter filterWithName:@"CIPixellate" keysAndValues:kCIInputImageKey, beginImage, @"inputScale", @10.0, nil];
    
    CIFilter *bumpDistortion = [CIFilter filterWithName:@"CIBumpDistortion" keysAndValues:kCIInputImageKey, beginImage, @"inputScale", @0.8, @"inputCenter", [CIVector vectorWithCGPoint:CGPointMake(160, 120)], @"inputRadius", @150, nil];
    
    CIFilter *minimum = [CIFilter filterWithName:@"CIMinimumComponent" keysAndValues:kCIInputImageKey, beginImage, nil];
    
    CIFilter *circularScreen = [CIFilter filterWithName:@"CICircularScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputWidth", @10.0, nil];
    
    filtersArray = @[affineTransform, straightenFilter, vibrance, colorControls, colorInvert, highlightsAndShadows, blurFilter, pixellate, bumpDistortion, minimum, circularScreen];
    filterIndx = 0;
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupCGContext];
}

-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)amountSliderValueChanged:(UISlider *)slider {
    float slideValue = slider.value;
    
    CIImage *outputImage = [self oldPhoto:beginImage withAmount:slideValue];
    
    //New Code!
    
    if (maskMode) {
        outputImage = [self maskImage:outputImage];
    }
    
    outputImage = [self addBackgroundLayer:outputImage];
    
    //Old code
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
    [self.filterTitle setText:@"Sepia Tone Composite"];
}

-(CIImage *)addBackgroundLayer:(CIImage *)inputImage {
    UIImage *backImage = [UIImage imageNamed:@"bryce.png"];
    CIImage *bg = [CIImage imageWithCGImage:backImage.CGImage];
    CIFilter *sourceOver = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, inputImage,  @"inputBackgroundImage", bg, nil];
    return sourceOver.outputImage;
}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    //1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    
    //2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    //3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    //4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[beginImage extent]];
    
    //5
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
    
    //6
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];
    
    //7
    return vignette.outputImage;
}

- (IBAction)savePhoto:(id)sender {
    CIImage *saveToSave = [filter outputImage];
    // 2
    CIContext *softwareContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)} ];
    // 3
    CGImageRef cgImg = [softwareContext createCGImage:saveToSave fromRect:[saveToSave extent]];
    // 4
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg metadata:[saveToSave properties] completionBlock:^(NSURL *assetURL, NSError *error) {
        // 5
        CGImageRelease(cgImg);
    }];
}


- (IBAction)maskModeOn:(id)sender {
    if (maskMode) {
        maskMode = NO;
        [self.maskModeButton setTitle:@"Mask Mode On" forState:UIControlStateNormal];
    } else {
        maskMode = YES;
        [self.maskModeButton setTitle:@"Mask Mode Off" forState:UIControlStateNormal];
    }
    [self amountSliderValueChanged:self.amountSlider];
}

- (IBAction)rotateFilter:(id)sender {
    CIFilter *filt = [filtersArray objectAtIndex:filterIndx];
    CGImageRef imgRef = [context createCGImage:filt.outputImage fromRect:[filt.outputImage extent]];
    [self.imageView setImage:[UIImage imageWithCGImage:imgRef]];
    CGImageRelease(imgRef);
    filterIndx = (filterIndx + 1) % [filtersArray count];
    [self.filterTitle setText:[[filt attributes ] valueForKey:@"CIAttributeFilterDisplayName"]];
}

- (IBAction)autoEnhance:(id)sender {
    CIImage *outputImage = beginImage;
    NSArray *ar = [beginImage autoAdjustmentFilters];
    for (CIFilter *fil in ar) {
        [fil setValue:outputImage forKey:kCIInputImageKey];
        outputImage = fil.outputImage;
        NSLog(@"%@", [[fil attributes] valueForKey:@"CIAttributeFilterDisplayName"]);
    }
    [filter setValue:outputImage forKey:kCIInputImageKey];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}

-(CIImage *)maskImage:(CIImage *)inputImage {
    
    CIFilter *maskFilter = [CIFilter filterWithName:@"CISourceAtopCompositing" keysAndValues:kCIInputImageKey, inputImage, kCIInputBackgroundImageKey, maskImage, nil];
    return maskFilter.outputImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    gotImage = [gotImage scaleToSize:[beginImage extent].size];
    orientation = gotImage.imageOrientation;
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [self performSelectorInBackground:@selector(hasFace:) withObject:beginImage];
    [self amountSliderValueChanged:self.amountSlider];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView:self.imageView];
    if (loc.y <= self.imageView.frame.size.height && loc.y >= 0) {
        loc = CGPointMake(loc.x, self.imageView.frame.size.height - loc.y);
        CGImageRef cgimg = [self drawMyCircleMask:loc reset:YES];
        maskImage = [CIImage imageWithCGImage:cgimg];
        [self amountSliderValueChanged:self.amountSlider];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView:self.imageView];
    if (loc.y <= self.imageView.frame.size.height && loc.y >= 0) {
        loc = CGPointMake(loc.x, self.imageView.frame.size.height - loc.y);
        CGImageRef cgimg = [self drawMyCircleMask:loc reset:NO];
        maskImage = [CIImage imageWithCGImage:cgimg];
        [self amountSliderValueChanged:self.amountSlider];
    }
}

-(void)setupCGContext {
    NSUInteger width = (NSUInteger )self.imageView.frame.size.width;
    NSUInteger height = (NSUInteger )self.imageView.frame.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    cgcontext = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
}

-(CGImageRef)drawMyCircleMask:(CGPoint)location reset:(BOOL)reset {
    if (reset) {
        CGContextClearRect(cgcontext, CGRectMake(0, 0, 320, self.imageView.frame.size.height));
    }
    CGContextSetRGBFillColor(cgcontext, 1, 1, 1, .7);
    CGContextFillEllipseInRect(cgcontext, CGRectMake(location.x - 25, location.y - 25, 50.0, 50.0));
    CGImageRef cgImg = CGBitmapContextCreateImage(cgcontext);
    return cgImg;
}

#pragma mark face detection 
- (void)hasFace:(CIImage *)image {
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{ CIDetectorAccuracy: CIDetectorAccuracyHigh} ];
    
    NSArray *features = [faceDetector featuresInImage:image]; NSLog(@"%@", features);
    beginImage = [self filteredFace:features onImage:beginImage];
    [self amountSliderValueChanged:self.amountSlider];

}

-(CIImage *)createBox:(CGPoint)loc color:(CIColor *)color {
    CIFilter *constantColor = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor", color, nil];
    CIFilter *crop = [CIFilter filterWithName:@"CICrop"];
    [crop setValue:constantColor.outputImage forKey:kCIInputImageKey];
    [crop setValue:[CIVector vectorWithCGRect:CGRectMake(loc.x - 3, loc.y - 3, 6, 6)] forKey:@"inputRectangle"];
    return  crop.outputImage;
}

-(CIImage *)filteredFace:(NSArray *)features onImage:(CIImage *)inputImage {
    CIImage *outputImage = inputImage;
    for (CIFaceFeature *f in features) {
        if (f.hasLeftEyePosition) {
            CIImage *box = [self createBox:CGPointMake(f.leftEyePosition.x, f.leftEyePosition.y) color:[CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7]];
            
            outputImage = [CIFilter filterWithName: @"CISourceAtopCompositing" keysAndValues:kCIInputImageKey, box, kCIInputBackgroundImageKey, outputImage, nil].outputImage;
        }
        if (f.hasRightEyePosition) {
            CIImage *box = [self createBox:CGPointMake(f.rightEyePosition.x, f.rightEyePosition.y) color:[CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7]];
            
            outputImage = [CIFilter filterWithName: @"CISourceAtopCompositing" keysAndValues:kCIInputImageKey, box, kCIInputBackgroundImageKey, outputImage, nil].outputImage;
        }
        if (f.hasMouthPosition) {
            CIImage *box = [self createBox:CGPointMake(f.mouthPosition.x, f.mouthPosition.y) color:[CIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.7]];
            
            outputImage = [CIFilter filterWithName: @"CISourceAtopCompositing" keysAndValues:kCIInputImageKey, box, kCIInputBackgroundImageKey, outputImage, nil].outputImage;
        }
    }
    return outputImage;
}


@end
