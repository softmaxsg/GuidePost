//
//  AppDelegate.m
//  GuidePost
//
//  Created by Vitaly Chupryk on 22.10.14.
//  Copyright (c) 2014 SoftMax SG. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+ColorUtils.h"

@interface AppDelegate ()

- (void)configureNavigationBarsAppearance;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureNavigationBarsAppearance];

    return YES;
}

- (void)configureNavigationBarsAppearance
{
    UINavigationBar *appearance = [UINavigationBar appearance];

    appearance.barStyle = UIBarStyleBlackOpaque;
    appearance.barTintColor = [UIColor colorWithRGB:0x01a260];
    appearance.tintColor = [UIColor whiteColor];
    appearance.titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:28] };
}

@end
