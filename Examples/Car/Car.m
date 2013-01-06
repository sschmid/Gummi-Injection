//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Car.h"
#import "GIInjector.h"
#import "Wheel.h"


@implementation Car

inject(@"leftFrontWheel", @"rightFrontWheel", @"leftRearWheel", @"rightRearWheel", @"motor");
@synthesize leftFrontWheel = _leftFrontWheel;
@synthesize rightFrontWheel = _rightFrontWheel;
@synthesize leftRearWheel = _leftRearWheel;
@synthesize rightRearWheel = _rightRearWheel;

@synthesize motor = _motor;

+ (id)car {
    return [[self alloc] init];
}

- (uint)numWheels {
    uint wheels = 0;
    if (self.rightFrontWheel)
        wheels++;
    if (self.leftFrontWheel)
        wheels++;
    if (self.leftRearWheel)
        wheels++;
    if (self.rightRearWheel)
        wheels++;

    return wheels;
}

- (BOOL)canDrive {
    BOOL hasAllWheels = self.numWheels == 4;
    BOOL hasLFW = [self.leftFrontWheel isKindOfClass:[Wheel class]];
    BOOL hasRFW = [self.rightFrontWheel isKindOfClass:[Wheel class]];
    BOOL hasLRW = [self.leftRearWheel isKindOfClass:[Wheel class]];
    BOOL hasRRW = [self.rightRearWheel isKindOfClass:[Wheel class]];

    return hasAllWheels && hasLFW && hasRFW && hasLRW && hasRRW && self.motor != nil;
}

@end