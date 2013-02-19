//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ExternalColoredBalloon.h"

@implementation ExternalColoredBalloon

- (id)initWithColor:(NSString *)color {
    self = [super init];
    if (self) {
        self.color = color;
    }

    return self;
}

- (void)inflate {
    if (self.air)
        self.inflated = YES;
}

@end