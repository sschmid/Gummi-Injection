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

    // Declare default initializer for ExternalColoredBalloon
    [_injector setDefaultInitializer:@selector(initWithColor:) forClass:[ExternalColoredBalloon class]];

    // Define all property names, which should be injected into
    [_injector addDependencies:@[@"air"] forClass:[ExternalColoredBalloon class]];

    // Define a selector that gets called, once all dependencies are satisfied
    [_injector setInjectionCompleteSelector:@selector(inflate) forClass:[ExternalColoredBalloon class]];

    // No need to map ExternalColoredBalloon. Gummi Injection figures that one out itself
    //[_injector map:[ExternalColoredBalloon class] to:[ExternalColoredBalloon class]];

    [_injector setDefaultInitializer:@selector(initAsO2) forClass:[ExternalAir class]];

    // No need to map ExternalAir. Gummi Injection figures that one out itself
    // [_injector map:[ExternalAir class] to:[ExternalAir class]];
}

@end