//
//  AppDelegate.m
//  Gummi-DI
//
//  Created by Simon Schmid on 14.12.12.
//  Copyright (c) 2012 Simon Schmid. All rights reserved.
//

#import "AppDelegate.h"
#import "CarExample.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[CarExample alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
