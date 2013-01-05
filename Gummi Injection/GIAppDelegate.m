//
// Created by Simon Schmid
//
// contact@sschmid.com
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
