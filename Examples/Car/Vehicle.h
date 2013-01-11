//
// Created by Simon Schmid
//
// contact@sschmid.com
//

@protocol Motor;
@class Wheel;

@protocol Vehicle <NSObject>

@property(nonatomic, strong) Wheel *leftFrontWheel;
@property(nonatomic, strong) Wheel *rightFrontWheel;
@property(nonatomic, strong) Wheel *leftRearWheel;
@property(nonatomic, strong) Wheel *rightRearWheel;

@property(nonatomic, readonly) uint numWheels;
@property(nonatomic) id <Motor> motor;

@property(nonatomic, readonly) BOOL canDrive;

@end