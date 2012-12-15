//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Garage.h"
#import "Car.h"
#import "GummiDI.h"


@implementation Garage

inject(@"audi", @"bmw", @"mercedes")
@synthesize audi = _audi;
@synthesize bmw = _bmw;
@synthesize mercedes = _mercedes;

- (BOOL)isFull {
    return self.audi != nil && self.bmw != nil && self.mercedes != nil;
 }

@end