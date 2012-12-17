//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


@protocol Motor;
@class Wheel;

@protocol Vehicle <NSObject>
@property(nonatomic, strong) Wheel *frontLeftWheel;
@property(nonatomic, strong) Wheel *frontRightWheel;
@property(nonatomic, strong) Wheel *backLeftWheel;
@property(nonatomic, strong) Wheel *backRightWheel;

@property(nonatomic, readonly) uint numWheels;
@property(nonatomic, readonly) BOOL canDrive;

@property(nonatomic) id <Motor> motor;
@property(nonatomic) float fuelLevel;
@property(nonatomic, readonly, getter=isFuelEmpty) BOOL fuelEmpty;
@property(nonatomic, copy) void (^onMotorDidStartBlock)();
@property(nonatomic) SEL onMotorDidStartSel;

@end