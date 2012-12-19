//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "GarageExample.h"
#import "Motor.h"
#import "SDInjector.h"
#import "HybridMotor.h"
#import "Garage.h"


@implementation GarageExample

- (id)init {
    self = [super init];
    if (self) {
        SDInjector *injector = [SDInjector sharedInjector];

        // No need to set up rules for simple injections that can be created with alloc init - Car and Wheels get injected automatically.
        // For protocols there's no way to know which implementation to return - we need to set up a rule for it.
        [injector map:@protocol(Motor) to:[HybridMotor class]];

        // Injector creates Cars and injects Wheels and Motor.
        Garage *garage = [injector getObject:[Garage class]];

        NSLog(@"Garage is full with cars: %@", garage.isFull == 0 ? @"NO" : @"YES"); // YES, all dependencies set
    }

    return self;
}

@end