//
//  JJFilterMakerViewController.m
//  FilterMaker
//
//  Created by Joshua Johnson on 4/30/12.
//  Copyright (c) 2012 jnjosh.com. All rights reserved.
//

#import "JJFilterMakerViewController.h"
#import "GPUImage.h"

@interface JJFilterMakerViewController ()

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) UIScrollView *filterScrollView;
@property (nonatomic, strong) GPUImagePicture *sourcePicture;

@property (nonatomic, strong) UISlider *saturationSlider;
@property (nonatomic, strong) UISlider *exposureSlider;
@property (nonatomic, strong) UISlider *gammaSlider;
@property (nonatomic, strong) UISlider *contrastSlider;
@property (nonatomic, strong) UISlider *brightnessSlider;

@property (nonatomic, strong) UISlider *colorRedSlider;
@property (nonatomic, strong) UISlider *colorGreenSlider;
@property (nonatomic, strong) UISlider *colorBlueSlider;

- (void)sliderValueChanged;
- (void)showOriginal;

@end

@implementation JJFilterMakerViewController

@synthesize imageView = _imageView, filterScrollView = _filterScrollView;
@synthesize saturationSlider = _saturationSlider, exposureSlider = _exposureSlider, gammaSlider = _gammaSlider, contrastSlider = _contrastSlider, brightnessSlider = _brightnessSlider;
@synthesize colorRedSlider = _colorRedSlider, colorGreenSlider = _colorGreenSlider, colorBlueSlider = _colorBlueSlider;
@synthesize sourcePicture = _sourcePicture;

#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

#pragma mark - view

- (void)loadView 
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    #warning TODO: This is all ugly - needs refactored to be less sucky
    
    CGFloat leftOffset = 10;
    CGFloat pageWidth = 320;
    
    self.imageView = [[GPUImageView alloc] initWithFrame:(CGRect){-100, 0, 480, 320}];
    [self.imageView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    [self.imageView setFillMode:kGPUImageFillModeStretch];
    [self.view addSubview:self.imageView];
    
    UIImageView *backingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageTray.png"]];
    [backingImageView setFrame:(CGRect){0, 320, pageWidth, 162}];
    [self.view addSubview:backingImageView];
    self.filterScrollView = [[UIScrollView alloc] initWithFrame:backingImageView.frame];
    [self.filterScrollView setBackgroundColor:[UIColor clearColor]];
    [self.filterScrollView setContentSize:(CGSize){ pageWidth * 6, 162 }];
    [self.filterScrollView setPagingEnabled:YES];
    [self.view addSubview:self.filterScrollView];
    
    // page 1
    UILabel *saturationLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [saturationLabel setText:@"Saturation"];
    [saturationLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [saturationLabel setBackgroundColor:[UIColor clearColor]];
    [saturationLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:saturationLabel];
    
    self.saturationSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset, 40, 300, 44 }];
    [self.saturationSlider setMinimumValue:0.0];
    [self.saturationSlider setMaximumValue:2.0];
    [self.saturationSlider setValue:1.0];
    [self.saturationSlider setContinuous:YES];
    [self.saturationSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.saturationSlider];
    
    // page 2
    leftOffset += pageWidth;
    UILabel *exposureLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [exposureLabel setText:@"Exposure"];
    [exposureLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [exposureLabel setBackgroundColor:[UIColor clearColor]];
    [exposureLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:exposureLabel];
    
    self.exposureSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset, 40, 300, 44 }];
    [self.exposureSlider setMinimumValue:-5.0];
    [self.exposureSlider setMaximumValue:5.0];
    [self.exposureSlider setValue:0.0];
    [self.exposureSlider setContinuous:YES];
    [self.exposureSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.exposureSlider];

    // page 3
    leftOffset += pageWidth;
    UILabel *gammaLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [gammaLabel setText:@"Gamma"];
    [gammaLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [gammaLabel setBackgroundColor:[UIColor clearColor]];
    [gammaLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:gammaLabel];
    
    self.gammaSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset, 40, 300, 44 }];
    [self.gammaSlider setMinimumValue:0.0];
    [self.gammaSlider setMaximumValue:2.0];
    [self.gammaSlider setValue:1.0];
    [self.gammaSlider setContinuous:YES];
    [self.gammaSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.gammaSlider];

    // page 4
    leftOffset += pageWidth;
    UILabel *contrastLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [contrastLabel setText:@"Contrast"];
    [contrastLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [contrastLabel setBackgroundColor:[UIColor clearColor]];
    [contrastLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:contrastLabel];

    self.contrastSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset, 40, 300, 44 }];
    [self.contrastSlider setMinimumValue:0.0];
    [self.contrastSlider setMaximumValue:2.0];
    [self.contrastSlider setValue:1.0];
    [self.contrastSlider setContinuous:YES];
    [self.contrastSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.contrastSlider];
   
    // page 5
    leftOffset += pageWidth;
    UILabel *brightnessLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [brightnessLabel setText:@"Brightness"];
    [brightnessLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [brightnessLabel setBackgroundColor:[UIColor clearColor]];
    [brightnessLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:brightnessLabel];
    
    self.brightnessSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset, 40, 300, 44 }];
    [self.brightnessSlider setMinimumValue:-1.0];
    [self.brightnessSlider setMaximumValue:1.0];
    [self.brightnessSlider setValue:0.0];
    [self.brightnessSlider setContinuous:YES];
    [self.brightnessSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.brightnessSlider];

    // page 6
    leftOffset += pageWidth;
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 10, 300, 22 }];
    [colorLabel setText:@"Color"];
    [colorLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [colorLabel setBackgroundColor:[UIColor clearColor]];
    [colorLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:colorLabel];
    
    UILabel *redLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 50, 80, 22 }];
    [redLabel setText:@"Red"];
    [redLabel setBackgroundColor:[UIColor clearColor]];
    [redLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:redLabel];
    
    self.colorRedSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 80, 40, 220, 44 }];
    [self.colorRedSlider setMinimumValue:0.0];
    [self.colorRedSlider setMaximumValue:2.0];
    [self.colorRedSlider setValue:1.0];
    [self.colorRedSlider setContinuous:YES];
    [self.colorRedSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorRedSlider];

    UILabel *greenLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 80, 80, 22 }];
    [greenLabel setText:@"Green"];
    [greenLabel setBackgroundColor:[UIColor clearColor]];
    [greenLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:greenLabel];
    
    self.colorGreenSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 80, 70, 220, 44 }];
    [self.colorGreenSlider setMinimumValue:0.0];
    [self.colorGreenSlider setMaximumValue:2.0];
    [self.colorGreenSlider setValue:1.0];
    [self.colorGreenSlider setContinuous:YES];
    [self.colorGreenSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorGreenSlider];

    UILabel *blueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 110, 80, 22 }];
    [blueLabel setText:@"Blue"];
    [blueLabel setBackgroundColor:[UIColor clearColor]];
    [blueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:blueLabel];
    
    self.colorBlueSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 80, 100, 220, 44 }];
    [self.colorBlueSlider setMinimumValue:0.0];
    [self.colorBlueSlider setMaximumValue:2.0];
    [self.colorBlueSlider setValue:1.0];
    [self.colorBlueSlider setContinuous:YES];
    [self.colorBlueSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorBlueSlider];

#warning TODO: No, really - This is all ugly - needs refactored... seriously
    
    // source image 
    #warning TODO: replace with camera captured or photo library image
    UIImage *inputImage = [UIImage imageNamed:@"photo.png"];
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];

    [self sliderValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.filterScrollView = nil;
    self.imageView = nil;
    self.saturationSlider = nil;
    self.exposureSlider = nil;
    self.gammaSlider = nil;
    self.contrastSlider = nil;
    self.brightnessSlider = nil;
    self.sourcePicture = nil;
    self.colorRedSlider = nil;
    self.colorGreenSlider = nil;
    self.colorBlueSlider = nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showOriginal];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self sliderValueChanged];
}

- (void)sliderValueChanged {
    [self.sourcePicture removeAllTargets];

    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [saturationFilter setSaturation:self.saturationSlider.value];

    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
    [exposureFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [exposureFilter setExposure:self.exposureSlider.value];
    
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    [gammaFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [gammaFilter setGamma:self.gammaSlider.value];
    
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [contrastFilter setContrast:self.contrastSlider.value];
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [brightnessFilter setBrightness:self.brightnessSlider.value];
    
    GPUImageColorMatrixFilter *colorFilter = [[GPUImageColorMatrixFilter alloc] init];
    [colorFilter setIntensity:0.4];
    [colorFilter setColorMatrix:(GPUMatrix4x4){
        {self.colorRedSlider.value, 0.0, 0.0, 0.0}, // RED
        {0.0, self.colorGreenSlider.value, 0.0, 0.0}, // GREEN
        {0.0, 0.0, self.colorBlueSlider.value, 0.0}, // BLUE
        {0.0, 0.0, 0.0, 1.0}, // ALPHA
    }];

    [self.sourcePicture addTarget:exposureFilter];
    [exposureFilter addTarget:saturationFilter];
    [saturationFilter addTarget:gammaFilter];
    [gammaFilter addTarget:contrastFilter];
    [contrastFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:colorFilter];
    [colorFilter addTarget:self.imageView];
    
    [self.sourcePicture processImage];
}

- (void)showOriginal {
    [self.sourcePicture removeAllTargets];
    [self.sourcePicture forceProcessingAtSize:self.imageView.sizeInPixels];
    [self.sourcePicture addTarget:self.imageView];
    [self.sourcePicture processImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
