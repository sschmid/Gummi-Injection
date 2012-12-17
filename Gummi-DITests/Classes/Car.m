//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import "Car.h"
#import "SDInjector.h"
#import "Wheel.h"


@implementation Car

inject(@"frontLeftWheel", @"frontRightWheel", @"backLeftWheel", @"backRightWheel", @"motor");
@synthesize frontLeftWheel = _frontLeftWheel;
@synthesize frontRightWheel = _frontRightWheel;
@synthesize backLeftWheel = _backLeftWheel;
@synthesize backRightWheel = _backRightWheel;

@synthesize motor = _motor;
@synthesize fuelLevel = _fuelLevel;
@synthesize fuelEmpty = _fuelEmpty;
@synthesize onMotorDidStartBlock = _onMotorDidStartBlock;


+ (id)car {
    return [[self alloc] init];
}

- (uint)numWheels {
    uint wheels = 0;
    if (self.frontRightWheel)
        wheels++;
    if (self.frontLeftWheel)
        wheels++;
    if (self.backLeftWheel)
        wheels++;
    if (self.backRightWheel)
        wheels++;

    return wheels;
}

- (BOOL)canDrive {
    BOOL hasAllWheels = self.numWheels == 4;
    BOOL hasFLW = [self.frontLeftWheel isKindOfClass:[Wheel class]];
    BOOL hasFRW = [self.frontRightWheel isKindOfClass:[Wheel class]];
    BOOL hasBLW = [self.backLeftWheel isKindOfClass:[Wheel class]];
    BOOL hasBRW = [self.backRightWheel isKindOfClass:[Wheel class]];

    return hasAllWheels && hasBLW && hasFLW && hasFRW && hasBRW && self.motor != nil;
}

@end