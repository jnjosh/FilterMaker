//
//  JJAppDelegate.m
//  FilterMaker
//
//  Created by Joshua Johnson on 4/30/12.
//  Copyright (c) 2012 jnjosh.com. All rights reserved.
//

#import "JJAppDelegate.h"
#import "JJFilterMakerViewController.h"

@interface JJAppDelegate ()
@property (nonatomic, strong) JJFilterMakerViewController *filterMakerViewController;
@end

@implementation JJAppDelegate

@synthesize window = _window, filterMakerViewController = _filterMakerViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.filterMakerViewController = [[JJFilterMakerViewController alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.filterMakerViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
