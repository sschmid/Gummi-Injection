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
@property(nonatomic, strong) Wheel *rearLeftWheel;
@property(nonatomic, strong) Wheel *rearRightWheel;

@property(nonatomic, readonly) uint numWheels;
@property(nonatomic) id <Motor> motor;

@property(nonatomic, readonly) BOOL canDrive;

@end