//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Garage.h"
#import "Car.h"
#import "SDInjector.h"


@implementation Garage

inject(@"audi", @"bmw", @"mercedes")
@synthesize audi = _audi;
@synthesize bmw = _bmw;
@synthesize mercedes = _mercedes;

- (BOOL)isFull {
    BOOL hasAllCars = self.audi != nil && self.bmw != nil && self.mercedes != nil;
    BOOL areAllCars = [self.audi isKindOfClass:[Car class]] && [self.bmw isKindOfClass:[Car class]] && [self.mercedes isKindOfClass:[Car class]];

    return hasAllCars && areAllCars;
 }

@end