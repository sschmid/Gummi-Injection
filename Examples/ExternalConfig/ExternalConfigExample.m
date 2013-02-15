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

        GIInjector *injector = [GIInjector sharedInjector];
        [injector addModule:[[ExternalConfigExampleModule alloc] init]];

        ExternalColoredBalloon *redBalloon = [injector getObject:[ExternalColoredBalloon class] withArgs:@[@"red"]];
        NSLog(@"redBalloon.color = %@", redBalloon.color);
        NSLog(@"redBalloon.air.type = %@", redBalloon.air.type);

        ExternalColoredBalloon *greenBalloon = [injector getObject:[ExternalColoredBalloon class] withArgs:@[@"green"]];
        NSLog(@"greenBalloon.color = %@", greenBalloon.color);
        NSLog(@"greenBalloon.air.type = %@", greenBalloon.air.type);

    }

    return self;
}

@end