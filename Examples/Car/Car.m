//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Car.h"
#import "GIInjector.h"
#import "Wheel.h"


@implementation Car

inject(@"frontLeftWheel", @"frontRightWheel", @"rearLeftWheel", @"rearRightWheel", @"motor");
@synthesize frontLeftWheel = _frontLeftWheel;
@synthesize frontRightWheel = _frontRightWheel;
@synthesize rearLeftWheel = _rearLeftWheel;
@synthesize rearRightWheel = _rearRightWheel;

@synthesize motor = _motor;

+ (id)car {
    return [[self alloc] init];
}

- (uint)numWheels {
    uint wheels = 0;
    if (self.frontRightWheel)
        wheels++;
    if (self.frontLeftWheel)
        wheels++;
    if (self.rearLeftWheel)
        wheels++;
    if (self.rearRightWheel)
        wheels++;

    return wheels;
}

- (BOOL)canDrive {
    BOOL hasAllWheels = self.numWheels == 4;
    BOOL hasFLW = [self.frontLeftWheel isKindOfClass:[Wheel class]];
    BOOL hasFRW = [self.frontRightWheel isKindOfClass:[Wheel class]];
    BOOL hasRLW = [self.rearLeftWheel isKindOfClass:[Wheel class]];
    BOOL hasRRW = [self.rearRightWheel isKindOfClass:[Wheel class]];

    return hasAllWheels && hasRLW && hasFLW && hasFRW && hasRRW && self.motor != nil;
}

@end