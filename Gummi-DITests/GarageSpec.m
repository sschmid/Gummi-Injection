//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Garage.h"
#import "Car.h"

SPEC_BEGIN(GarageSpec)

        describe(@"Garage", ^{

            __block Garage *garage;
            beforeEach(^{
                garage = [[Garage alloc] init];
            });

            it(@"instantiates a garage", ^{
                [[garage should] beKindOfClass:[Garage class]];
            });

            it(@"is not full", ^{
                [[theValue(garage.isFull) should] beNo];
            });

            it(@"is not full", ^{
                garage.audi = [Car car];
                garage.bmw = [Car car];

                [[theValue(garage.isFull) should] beNo];
            });

            it(@"is full", ^{
                garage.audi = [Car car];
                garage.bmw = [Car car];
                garage.mercedes = [Car car];

                [[theValue(garage.isFull) should] beYes];
            });

        });

        SPEC_END