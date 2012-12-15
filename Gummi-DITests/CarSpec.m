//
//  CarSpec.m
//  Gummi-DITests
//
//  Created by Simon Schmid on 14.12.12.
//  Copyright (c) 2012 Simon Schmid. All rights reserved.
//

#import "Kiwi.h"
#import "Car.h"
#import "Wheel.h"

SPEC_BEGIN(CarSpec)

        describe(@"Car", ^{

            __block Car *car;
            beforeEach(^{
                car = [Car car];
            });

            it(@"creates a car", ^{
                [[car should] beKindOfClass:[Car class]];
            });

            it(@"has no wheels", ^{
                [[theValue(car.numWheels) should] equal:theValue(0)];
            });

            it(@"creates a wheel", ^{
                [[[Wheel wheel] should] beKindOfClass:[Wheel class]];
            });

            it(@"adds wheels", ^{
                car.frontLeftWheel = [Wheel wheel];
                car.frontRightWheel = [Wheel wheel];
                car.backLeftWheel = [Wheel wheel];
                car.backRightWheel = [Wheel wheel];

                [[theValue(car.numWheels) should] equal:theValue(4)];
            });

        });

        SPEC_END
