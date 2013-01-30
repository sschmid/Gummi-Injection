//
// Created by Simon Schmid
//
// contact@sschmid.com
//

@protocol Engine;

@protocol Vehicle <NSObject>
@property(nonatomic) id <Engine> engine;
@property(nonatomic, readonly) uint numWheels;
@property(nonatomic, readonly) BOOL canDrive;
@end