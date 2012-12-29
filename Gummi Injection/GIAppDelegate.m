//
//  AppDelegate.m
//  Gummi-DI
//
//  Created by Simon Schmid on 14.12.12.
//  Copyright (c) 2012 Simon Schmid. All rights reserved.
//

#import "GIAppDelegate.h"
#import "GarageExample.h"

@implementation GIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[GarageExample alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
