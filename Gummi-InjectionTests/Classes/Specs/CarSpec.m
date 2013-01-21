//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "Car.h"
#import "Wheel.h"
#import "HybridMotor.h"

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

            it(@"has no motor", ^{
                BOOL hasMotor = car.motor != nil;
                [[theValue(hasMotor) should] beNo];
            });

            it(@"can not drive", ^{
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"creates a wheel", ^{
                [[[Wheel wheel] should] beKindOfClass:[Wheel class]];
            });

            it(@"creates a motor", ^{
                [[[HybridMotor motor] should] beKindOfClass:[HybridMotor class]];
                [[[HybridMotor motor] should] conformsToProtocol:@protocol(Motor)];
            });

            it(@"adds wheels", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];

                BOOL hasAllWheels = car.numWheels == 4;
                BOOL hasWheel1 = [car.wheel1 isKindOfClass:[Wheel class]];
                BOOL hasWheel2 = [car.wheel2 isKindOfClass:[Wheel class]];
                BOOL hasWheel3 = [car.wheel3 isKindOfClass:[Wheel class]];
                BOOL hasWheel4 = [car.wheel4 isKindOfClass:[Wheel class]];

                [[theValue(hasAllWheels && hasWheel1 && hasWheel2 && hasWheel3 && hasWheel4) should] beYes];
            });

            it(@"can not drive without motor", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];

                [[theValue(car.canDrive) should] beNo];
            });

            it(@"adds a motor", ^{
                car.motor = [HybridMotor motor];
                BOOL hasMotor = car.motor != nil;

                [[theValue(hasMotor) should] beYes];
            });

            it(@"can not drive without wheels", ^{
                car.motor = [HybridMotor motor];
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"can drive", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];
                car.motor = [HybridMotor motor];

                [[theValue(car.canDrive) should] beYes];
            });

        });

        SPEC_END
