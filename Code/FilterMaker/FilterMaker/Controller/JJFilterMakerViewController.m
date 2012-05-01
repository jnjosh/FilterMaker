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

@property (nonatomic, strong) UIImage *inputImage;
@property (nonatomic, strong) UIImageView *imageView;
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

@property (nonatomic, strong) UILabel *saturationValueLabel;
@property (nonatomic, strong) UILabel *exposureValueLabel;
@property (nonatomic, strong) UILabel *gammaValueLabel;
@property (nonatomic, strong) UILabel *contrastValueLabel;
@property (nonatomic, strong) UILabel *brightnessValueLabel;

@property (nonatomic, strong) UILabel *colorRedValueLabel;
@property (nonatomic, strong) UILabel *colorGreenValueLabel;
@property (nonatomic, strong) UILabel *colorBlueValueLabel;

- (void)sliderValueChanged;
- (void)showOriginal;

@end

@implementation JJFilterMakerViewController

@synthesize inputImage = _inputImage, imageView = _imageView, filterScrollView = _filterScrollView;
@synthesize saturationSlider = _saturationSlider, exposureSlider = _exposureSlider, gammaSlider = _gammaSlider, contrastSlider = _contrastSlider, brightnessSlider = _brightnessSlider;
@synthesize colorRedSlider = _colorRedSlider, colorGreenSlider = _colorGreenSlider, colorBlueSlider = _colorBlueSlider;
@synthesize saturationValueLabel = _saturationValueLabel, exposureValueLabel = _exposureValueLabel, gammaValueLabel = _gammaValueLabel, contrastValueLabel = _contrastValueLabel, brightnessValueLabel = _brightnessValueLabel;
@synthesize colorRedValueLabel = _colorRedValueLabel, colorBlueValueLabel = _colorBlueValueLabel, colorGreenValueLabel = _colorGreenValueLabel;
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
    
    self.imageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, 320, 320}];
    [self.imageView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
    
    self.saturationValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 90, 300, 22 }];
    [self.saturationValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.saturationValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.saturationValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.saturationValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.saturationValueLabel];
    
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
    
    self.exposureValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 90, 300, 22 }];
    [self.exposureValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.exposureValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.exposureValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.exposureValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.exposureValueLabel];

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
    
    self.gammaValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 90, 300, 22 }];
    [self.gammaValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.gammaValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.gammaValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.gammaValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.gammaValueLabel];

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
    
    self.contrastValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 90, 300, 22 }];
    [self.contrastValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.contrastValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.contrastValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.contrastValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.contrastValueLabel];
   
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
    
    self.brightnessValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 90, 300, 22 }];
    [self.brightnessValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.brightnessValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.brightnessValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.brightnessValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.brightnessValueLabel];

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
    
    self.colorRedSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 50, 40, 180, 44 }];
    [self.colorRedSlider setMinimumValue:0.0];
    [self.colorRedSlider setMaximumValue:2.0];
    [self.colorRedSlider setValue:1.0];
    [self.colorRedSlider setContinuous:YES];
    [self.colorRedSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorRedSlider];
    
    self.colorRedValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset + 230, 50, 80, 22 }];
    [self.colorRedValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.colorRedValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.colorRedValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.colorRedValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.colorRedValueLabel];

    UILabel *greenLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 80, 80, 22 }];
    [greenLabel setText:@"Green"];
    [greenLabel setBackgroundColor:[UIColor clearColor]];
    [greenLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:greenLabel];
    
    self.colorGreenSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 50, 70, 180, 44 }];
    [self.colorGreenSlider setMinimumValue:0.0];
    [self.colorGreenSlider setMaximumValue:2.0];
    [self.colorGreenSlider setValue:1.0];
    [self.colorGreenSlider setContinuous:YES];
    [self.colorGreenSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorGreenSlider];
    
    self.colorGreenValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset + 230, 80, 80, 22 }];
    [self.colorGreenValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.colorGreenValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.colorGreenValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.colorGreenValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.colorGreenValueLabel];

    UILabel *blueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset, 110, 80, 22 }];
    [blueLabel setText:@"Blue"];
    [blueLabel setBackgroundColor:[UIColor clearColor]];
    [blueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:blueLabel];
    
    self.colorBlueSlider = [[UISlider alloc] initWithFrame:(CGRect){ leftOffset + 50, 100, 180, 44 }];
    [self.colorBlueSlider setMinimumValue:0.0];
    [self.colorBlueSlider setMaximumValue:2.0];
    [self.colorBlueSlider setValue:1.0];
    [self.colorBlueSlider setContinuous:YES];
    [self.colorBlueSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.filterScrollView addSubview:self.colorBlueSlider];
    
    self.colorBlueValueLabel = [[UILabel alloc] initWithFrame:(CGRect){ leftOffset + 230, 110, 80, 22 }];
    [self.colorBlueValueLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.colorBlueValueLabel setTextAlignment:UITextAlignmentCenter];
    [self.colorBlueValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.colorBlueValueLabel setTextColor:[UIColor whiteColor]];
    [self.filterScrollView addSubview:self.colorBlueValueLabel];

#warning TODO: No, really - This is all ugly - needs refactored... seriously
    
    // source image 
    #warning TODO: replace with camera captured or photo library image
    self.inputImage = [UIImage imageNamed:@"6.png"];
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:self.inputImage smoothlyScaleOutput:NO];
    
    [self sliderValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [saturationFilter setSaturation:self.saturationSlider.value];
    [self.saturationValueLabel setText:[NSString stringWithFormat:@"%f", self.saturationSlider.value]];

    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
    [exposureFilter setExposure:self.exposureSlider.value];
    [self.exposureValueLabel setText:[NSString stringWithFormat:@"%f", self.exposureSlider.value]];
    
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    [gammaFilter setGamma:self.gammaSlider.value];
    [self.gammaValueLabel setText:[NSString stringWithFormat:@"%f", self.gammaSlider.value]];
    
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:self.contrastSlider.value];
    [self.contrastValueLabel setText:[NSString stringWithFormat:@"%f", self.contrastSlider.value]];
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:self.brightnessSlider.value];
    [self.brightnessValueLabel setText:[NSString stringWithFormat:@"%f", self.brightnessSlider.value]];
    
    GPUImageColorMatrixFilter *colorFilter = [[GPUImageColorMatrixFilter alloc] init];
    [colorFilter setIntensity:0.4];
    [colorFilter setColorMatrix:(GPUMatrix4x4){
        {self.colorRedSlider.value, 0.0, 0.0, 0.0}, // RED
        {0.0, self.colorGreenSlider.value, 0.0, 0.0}, // GREEN
        {0.0, 0.0, self.colorBlueSlider.value, 0.0}, // BLUE
        {0.0, 0.0, 0.0, 1.0}, // ALPHA
    }];
    [self.colorRedValueLabel setText:[NSString stringWithFormat:@"%f", self.colorRedSlider.value]];
    [self.colorGreenValueLabel setText:[NSString stringWithFormat:@"%f", self.colorGreenSlider.value]];
    [self.colorBlueValueLabel setText:[NSString stringWithFormat:@"%f", self.colorBlueSlider.value]];

    [self.sourcePicture addTarget:exposureFilter];
    [exposureFilter addTarget:saturationFilter];
    [saturationFilter addTarget:gammaFilter];
    [gammaFilter addTarget:contrastFilter];
    [contrastFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:colorFilter];
    
    [self.sourcePicture processImage];
    [self.imageView setImage:[colorFilter imageFromCurrentlyProcessedOutput]];
}

- (void)showOriginal {
    [self.imageView setImage:self.inputImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
