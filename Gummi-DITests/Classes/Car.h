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
+ (id)car;

@end