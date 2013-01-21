//
// Created by Simon Schmid
//
// contact@sschmid.com
//

@protocol Motor;

@protocol Vehicle <NSObject>
@property(nonatomic) id <Motor> motor;
@property(nonatomic, readonly) uint numWheels;
@property(nonatomic, readonly) BOOL canDrive;
@end