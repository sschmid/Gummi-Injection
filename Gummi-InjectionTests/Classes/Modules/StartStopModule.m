//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "StartStopModule.h"
#import "GIInjector.h"
#import "StartStopObject.h"

@implementation StartStopModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[StartStopObject class] to:[StartStopObject class]];

    StartStopObject *startStopObject = [_injector getObject:[StartStopObject class]];
    [startStopObject start];
}

- (void)unload {
    StartStopObject *startStopObject = [_injector getObject:[StartStopObject class]];
    [startStopObject stop];

    [super unload];
}

@end