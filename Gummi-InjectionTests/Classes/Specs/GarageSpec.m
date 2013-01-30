//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "Garage.h"
#import "Car.h"
#import "Wheel.h"
#import "HybridEngine.h"

SPEC_BEGIN(GarageSpec)

        Car *(^buildCar)() = ^() {
            Car *car = [[Car alloc] init];
            car.wheel1 = [[Wheel alloc] init];
            car.wheel2 = [[Wheel alloc] init];
            car.wheel3 = [[Wheel alloc] init];
            car.wheel4 = [[Wheel alloc] init];
            car.engine = [[HybridEngine alloc] init];
            return car;
        };

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
                garage.audi = buildCar();
                garage.bmw = buildCar();
                garage.mercedes = buildCar();

                [[theValue(garage.isFull) should] beYes];
            });

        });

        SPEC_END