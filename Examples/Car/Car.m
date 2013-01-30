//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Car.h"
#import "GIInjector.h"
#import "Wheel.h"

@implementation Car

inject(@"wheel1", @"wheel2", @"wheel3", @"wheel4", @"engine");
injection_complete(@selector(startEngine))

+ (id)car {
    return [[self alloc] init];
}

- (uint)numWheels {
    uint wheels = 0;
    if (self.wheel1)
        wheels++;
    if (self.wheel2)
        wheels++;
    if (self.wheel3)
        wheels++;
    if (self.wheel4)
        wheels++;

    return wheels;
}

- (BOOL)canDrive {
    BOOL hasAllWheels = self.numWheels == 4;
    BOOL hasWheel1 = [self.wheel1 isKindOfClass:[Wheel class]];
    BOOL hasWheel2 = [self.wheel2 isKindOfClass:[Wheel class]];
    BOOL hasWheel3 = [self.wheel3 isKindOfClass:[Wheel class]];
    BOOL hasWheel4 = [self.wheel4 isKindOfClass:[Wheel class]];

    return hasAllWheels && hasWheel1 && hasWheel2 && hasWheel3 && hasWheel4 && self.engine != nil;
}

- (void)startEngine {
    if (self.engine)
        NSLog(@"[%@] Brrrmmmmm....", NSStringFromClass([self class]));
}

@end