//
// Created by sschmid on 14.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Wheel.h"
#import "Car.h"

SPEC_BEGIN(SetPropertiesOnObjectSpec)

        describe(@"SetPropertiesOnObjectSpec", ^{

            it(@"sets properties from dictionary", ^{

                NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
                [props setObject:[Wheel wheel] forKey:@"frontLeftWheel"];
                [props setObject:[Wheel wheel] forKey:@"frontRightWheel"];
                [props setObject:[Wheel wheel] forKey:@"backLeftWheel"];
                [props setObject:[Wheel wheel] forKey:@"backRightWheel"];

                Car *car = [Car car];
                [car setValuesForKeysWithDictionary:props];

                [[theValue(car.numWheels) should] equal:theValue(4)];
            });

        });

        SPEC_END
