//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@class Wheel;

@interface Car : NSObject <Vehicle>
@property(nonatomic, strong) Wheel *wheel1;
@property(nonatomic, strong) Wheel *wheel2;
@property(nonatomic, strong) Wheel *wheel3;
@property(nonatomic, strong) Wheel *wheel4;
@property(nonatomic) id <Engine> engine;

+ (id)car;
@end