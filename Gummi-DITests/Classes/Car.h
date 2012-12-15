//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "Vehicle.h"

@class Wheel;
@protocol Motor;


@interface Car : NSObject <Vehicle>
@property(nonatomic, strong) Wheel *frontLeftWheel;
@property(nonatomic, strong) Wheel *frontRightWheel;
@property(nonatomic, strong) Wheel *backLeftWheel;
@property(nonatomic, strong) Wheel *backRightWheel;

@property(nonatomic) id <Motor> motor;
@property(nonatomic) float fuelLevel;
@property(nonatomic, readonly, getter=isFuelEmpty) BOOL fuelEmpty;
@property(nonatomic, copy) void (^onMotorDidStartBlock)();
@property(nonatomic) SEL onMotorDidStartSel;

+ (id)car;

- (uint)numWheels;

@end