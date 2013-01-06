//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "Vehicle.h"

@class Wheel;
@protocol Motor;

@interface Car : NSObject <Vehicle>
+ (id)car;
@end