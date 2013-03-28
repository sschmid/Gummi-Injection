//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ExternalConfigExample.h"
#import "GIInjector.h"
#import "ExternalConfigExampleModule.h"
#import "ExternalColoredBalloon.h"
#import "ExternalAir.h"

@implementation ExternalConfigExample

- (id)init {
    self = [super init];
    if (self) {

        // The sources of ExternalColoredBalloon do not contain any Gummi Injection code.
        // ExternalColoredBalloon is configured externally in ExternalConfigExampleModule

        GIInjector *injector = [GIInjector sharedInjector];
        [injector addModule:[[ExternalConfigExampleModule alloc] init]];

        ExternalColoredBalloon *redBalloon = [injector getObject:[ExternalColoredBalloon class] withArgs:@[@"red"]];
        NSLog(@"redBalloon.color = %@", redBalloon.color);
        NSLog(@"redBalloon.air.type = %@", redBalloon.air.type);
        NSLog(@"redBalloon.inflated = %d", redBalloon.inflated);

        // or use macro
        ExternalColoredBalloon *greenBalloon = getObjectWithArgs([ExternalColoredBalloon class], @[@"green"]);
        NSLog(@"greenBalloon.color = %@", greenBalloon.color);
        NSLog(@"greenBalloon.air.type = %@", greenBalloon.air.type);
        NSLog(@"greenBalloon.inflated = %d", greenBalloon.inflated);

    }

    return self;
}

@end