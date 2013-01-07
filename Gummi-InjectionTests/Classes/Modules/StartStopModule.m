//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "StartStopModule.h"
#import "GIInjector.h"
#import "StartStopObject.h"


@implementation StartStopModule
@synthesize startStopObject = _startStopObject;

- (void)configure:(GIInjector *)injector {
    [super configure:injector];
    
    self.startStopObject = [_injector getObject:[StartStopObject class]];
    [self.startStopObject start];
}

- (void)unload {
    [self.startStopObject stop];
    [super unload];
}

@end