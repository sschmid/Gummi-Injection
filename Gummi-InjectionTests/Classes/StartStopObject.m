//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "StartStopObject.h"


@implementation StartStopObject
@synthesize started = _started;

- (void)start {
    self.started = YES;
}

- (void)stop {
    self.started = NO;
}

@end