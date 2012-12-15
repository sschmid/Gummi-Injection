//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import "Car.h"
#import "SDInjector.h"


@implementation Car

inject(@"frontLeftWheel", @"frontRightWheel", @"backLeftWheel", @"backRightWheel");
@synthesize frontLeftWheel = _frontLeftWheel;
@synthesize frontRightWheel = _frontRightWheel;
@synthesize backLeftWheel = _backLeftWheel;
@synthesize backRightWheel = _backRightWheel;

@synthesize motor = _motor;
@synthesize fuelLevel = _fuelLevel;
@synthesize fuelEmpty = _fuelEmpty;
@synthesize onMotorDidStartBlock = _onMotorDidStartBlock;
@synthesize onMotorDidStartSel = _onMotorDidStartSel;


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

@end