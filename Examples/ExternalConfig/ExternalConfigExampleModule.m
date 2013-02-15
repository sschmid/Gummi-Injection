//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ExternalConfigExampleModule.h"
#import "GIInjector.h"
#import "ExternalColoredBalloon.h"
#import "ExternalAir.h"

@implementation ExternalConfigExampleModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [_injector setDefaultInitializer:@selector(initWithColor:) forClass:[ExternalColoredBalloon class]];
    [_injector addDependencies:@[@"air"] forClass:[ExternalColoredBalloon class]];

    // No need to map ExternalColoredBalloon. Gummi Injection figures that one out itself
    //[_injector map:[ExternalColoredBalloon class] to:[ExternalColoredBalloon class]];

    [_injector setDefaultInitializer:@selector(initDefaultInitializer) forClass:[ExternalAir class]];

    // No need to map ExternalAir. Gummi Injection figures that one out itself
    // [_injector map:[ExternalAir class] to:[ExternalAir class]];
}

@end